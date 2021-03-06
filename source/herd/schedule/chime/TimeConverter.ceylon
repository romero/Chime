import ceylon.time {
	
	DateTime,
	Instant
}
import java.util {
	
	JavaTimeZone=TimeZone
}
import ceylon.json {

	JSON=Object
}
import herd.schedule.chime.timer {

	definitions
}


"Converting date-time according to rule (timezone)."
by( "Lis" )
interface TimeConverter {
	
	"Converts remote date-time to local one."
	shared formal DateTime toLocal( "Date-time to convert from." DateTime remote );
	
	"Converts local date-time to remote one."
	shared formal DateTime toRemote( "Date-time to convert from." DateTime local );
	
	"Returns time zone id."
	shared formal String timeZoneID;
}


"Defines time converter which do no convertion."
by( "Lis" )
object dummyConverter satisfies TimeConverter {
	
	"Local time zone."
	shared JavaTimeZone local = JavaTimeZone.default;
	
	"Returns converter by time zone name."
	shared TimeConverter? getConverter( JSON description ) {
		if ( is String timeZoneID = description.get( definitions.timeZoneID ) ) {
			JavaTimeZone tz = JavaTimeZone.getTimeZone( timeZoneID );
			if ( tz.id == timeZoneID ) {
				return ConverterWithTimezone( tz );
			}
			else {
				return null;
			}
		}
		else {
			return dummyConverter;
		}
	}
	
	"Returns `remote`."
	shared actual DateTime toLocal( DateTime remote ) => remote;
	
	"Returns `local`."
	shared actual DateTime toRemote( DateTime local ) => local;
	
	shared actual String timeZoneID => local.id;
	
}


"Converts according to specified remote time zone."
by( "Lis" )
class ConverterWithTimezone( JavaTimeZone remoteTimeZone ) satisfies TimeConverter {
	
	
	shared actual DateTime toLocal( DateTime remote ) {
		Integer remoteTime = remote.instant().millisecondsOfEpoch;
		Integer utcTime = remoteTime - remoteTimeZone.getOffset( remoteTime );
		Integer localUTCOffset = dummyConverter.local.getOffset( utcTime + dummyConverter.local.getOffset( utcTime ) );
		return Instant( utcTime + localUTCOffset ).dateTime();
	}
	
	shared actual DateTime toRemote( DateTime local ) {
		Integer localTime = local.instant().millisecondsOfEpoch;
		Integer utcTime = localTime - dummyConverter.local.getOffset( localTime );
		Integer remoteUTCOffset = remoteTimeZone.getOffset( utcTime + remoteTimeZone.getOffset( utcTime ) );
		return Instant( utcTime + remoteUTCOffset ).dateTime();
	}
	
	shared actual String timeZoneID => remoteTimeZone.id;
	
}

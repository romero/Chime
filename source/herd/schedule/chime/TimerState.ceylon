

"Timer state - running, paused or completed."
by( "Lis" )
abstract class TimerState()
	of timerRunning | timerPaused | timerCompleted
{
	
	"Returns timer state by name: 
	 * \"paused\" - timerPaused
	 * \"running\" - timerRunning
	 * \"completed\" - timerCompleted
	 * otherwise - null
	 "
	shared TimerState? byName( String name ) {
		if ( name == timerPaused.string ) {
			return timerPaused;
		}
		else if ( name == timerRunning.string ) {
			return timerRunning;
		}
		else if ( name == timerCompleted.string ) {
			return timerCompleted;
		}
		else {
			return null;
		}
	}
}

"Timer running state."
by( "Lis" )
object timerRunning extends TimerState()
{
	shared actual String string = "running";
}

"Timer paused state."
by( "Lis" )
object timerPaused extends TimerState()
{
	shared actual String string = "paused";
}

"Timer completed state."
by( "Lis" )
object timerCompleted extends TimerState()
{
	shared actual String string = "completed";
}

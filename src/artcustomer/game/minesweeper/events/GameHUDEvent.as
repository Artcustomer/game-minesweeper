package artcustomer.game.minesweeper.events {
	import flash.events.Event;
	
	
	/**
	 * GameHUDEvent
	 * 
	 * @author David Massenot
	 */
	public class GameHUDEvent extends Event {
		public static const ON_PRESS_RESTART:String = 'onPressRestart';
		public static const ON_PRESS_QUIT:String = 'onPressQuit';
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function GameHUDEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone GameHUDEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GameHUDEvent(type, bubbles, cancelable);
		}
		
		/**
		 * Get String format of GameHUDEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GameHUDEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}
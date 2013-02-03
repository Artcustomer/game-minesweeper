package artcustomer.game.minesweeper.events {
	import flash.events.Event;
	
	
	/**
	 * GameTimerEvent
	 * 
	 * @author David Massenot
	 */
	public class GameTimerEvent extends Event {
		public static const ON_TICK:String = 'onTick';
		public static const ON_TIME_LIMIT:String = 'onTimeLimit';
		
		private var _tick:int;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	tick
		 */
		public function GameTimerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, tick:int = 0) {
			_tick = tick;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone GameTimerEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GameTimerEvent(type, bubbles, cancelable, _tick);
		}
		
		/**
		 * Get String format of GameTimerEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GameTimerEvent", "type", "bubbles", "cancelable", "eventPhase", "tick"); 
		}
		
		
		/**
		 * @private
		 */
		public function get tick():int {
			return _tick;
		}
	}
}
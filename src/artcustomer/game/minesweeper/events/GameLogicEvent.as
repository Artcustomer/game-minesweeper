package artcustomer.game.minesweeper.events {
	import flash.events.Event;
	
	
	/**
	 * GameLogicEvent
	 * 
	 * @author David Massenot
	 */
	public class GameLogicEvent extends Event {
		public static const ON_GAME_START:String = 'onGameStart';
		public static const ON_GAME_OVER:String = 'onGameOver';
		public static const ON_GAME_WIN:String = 'onGameWin';
		public static const MINE_COUNT_CHANGE:String = 'mineCountChange';
		
		private var _mineCount:int;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	mineCount
		 */
		public function GameLogicEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, mineCount:int = 0) {
			_mineCount = mineCount;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone GameLogicEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GameLogicEvent(type, bubbles, cancelable, _mineCount);
		}
		
		/**
		 * Get String format of GameLogicEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GameLogicEvent", "type", "bubbles", "cancelable", "eventPhase", "mineCount"); 
		}
		
		
		/**
		 * @private
		 */
		public function get mineCount():int {
			return _mineCount;
		}
	}
}
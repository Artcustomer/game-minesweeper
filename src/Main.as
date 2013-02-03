/**
	 * Game - Mine Sweeper
	 * 01 / 02 / 2013
	 * 
     * @langversion 3.0
     * @playerversion Flash 11.6
     * @author David Massenot (http://artcustomer.fr)
	 * @version 1.0.0.0
**/
package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import artcustomer.game.minesweeper.api.MineSweeperGame;
	
	
	/**
	 * Main Class
	 * 
	 * @author David Massenot
	 */
	public class Main extends Sprite {
		private var _game:MineSweeperGame;
		
		
		/**
		 * Constructor
		 */
		public function Main():void {
			Security.allowInsecureDomain('*');
			
			this.addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function added(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, added);
			
			setupGame();
		}
		
		/**
		 * @private
		 */
		private function removed(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			destroyGame();
		}
		
		//---------------------------------------------------------------------
		//  MineSweeperGame
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupGame():void {
			_game = new MineSweeperGame();
			_game.contextView = this;
			_game.setup();
		}
		
		/**
		 * @private
		 */
		private function destroyGame():void {
			if (_game) {
				_game.destroy();
				_game = null;
			}
		}
	}
}
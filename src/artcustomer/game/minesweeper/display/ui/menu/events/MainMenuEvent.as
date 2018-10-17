package artcustomer.game.minesweeper.display.ui.menu.events {
	import flash.events.Event;
	
	
	/**
	 * MainMenuEvent
	 * 
	 * @author David Massenot
	 */
	public class MainMenuEvent extends Event {
		public static const ON_HIDE_MENU:String = 'onHideMenu';
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function MainMenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone MainMenuEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new MainMenuEvent(type, bubbles, cancelable);
		}
		
		/**
		 * Get String format of MainMenuEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("MainMenuEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}
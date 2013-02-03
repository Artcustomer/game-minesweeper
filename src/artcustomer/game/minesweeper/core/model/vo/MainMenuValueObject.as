package artcustomer.game.minesweeper.core.model.vo {
	import artcustomer.maxima.utils.tools.StringTools;
	
	import artcustomer.maxima.extensions.display.ui.list.data.AbstractListItemValueObject;
	
	
	/**
	 * MainMenuValueObject
	 * 
	 * @author David Massenot
	 */
	public class MainMenuValueObject extends AbstractListItemValueObject {
		private var _type:String;
		private var _title:String;
		private var _difficulty:String;
		
		
		/**
		 * Constructor
		 */
		public function MainMenuValueObject() {
			super();
		}
		
		
		/**
		 * Destructor
		 */
		override public function destroy():void {
			_type = null;
			_title = null;
			_difficulty = null;
			
			super.destroy();
		}
		
		/**
		 * Get String format of object.
		 * 
		 * @return
		 */
		override public function toString():String {
			return StringTools.formatToString(this, 'MainMenuValueObject', 'type', 'title', 'difficulty');
		}
		
		
		/**
		 * @private
		 */
		public function get type():String {
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set type(value:String):void {
			_type = value;
		}
		
		/**
		 * @private
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * @private
		 */
		public function set title(value:String):void {
			_title = value;
		}
		
		/**
		 * @private
		 */
		public function get difficulty():String {
			return _difficulty;
		}
		
		/**
		 * @private
		 */
		public function set difficulty(value:String):void {
			_difficulty = value;
		}
	}
}
package artcustomer.game.minesweeper.core.model.mode.type {
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.utils.tools.StringTools;
	
	
	/**
	 * DifficultyMode
	 * 
	 * @author David Massenot
	 */
	public class DifficultyMode implements IDestroyable {
		private var _name:String;
		private var _type:String;
		private var _rows:int;
		private var _columns:int;
		private var _mines:int;
		
		
		/**
		 * Constructor
		 */
		public function DifficultyMode() {
			
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			_name = null;
			_type = null;
			_rows = 0;
			_columns = 0;
			_mines = 0;
		}
		
		/**
		 * Get String format of Object.
		 * 
		 * @return
		 */
		public function toString():String {
			return StringTools.formatToString(this, 'DifficultyMode', 'name', 'type', 'rows', 'columns', 'mines');
		}
		
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
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
		public function get type():String {
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set rows(value:int):void {
			_rows = value;
		}
		
		/**
		 * @private
		 */
		public function get rows():int {
			return _rows;
		}
		
		/**
		 * @private
		 */
		public function set columns(value:int):void {
			_columns = value;
		}
		
		/**
		 * @private
		 */
		public function get columns():int {
			return _columns;
		}
		
		/**
		 * @private
		 */
		public function set mines(value:int):void {
			_mines = value;
		}
		
		/**
		 * @private
		 */
		public function get mines():int {
			return _mines;
		}
	}
}
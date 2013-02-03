package artcustomer.game.minesweeper.events {
	import flash.events.Event;
	
	import artcustomer.game.minesweeper.core.game.logic.cells.MineCell;
	
	
	/**
	 * MineCellEvent
	 * 
	 * @author David Massenot
	 */
	public class MineCellEvent extends Event {
		public static const ON_CELL_SELECTED:String = 'onCellSelected';
		public static const ON_CELL_OPENED:String = 'onCellOpened';
		public static const ON_CELL_FLAGGED:String = 'onCellFlagged';
		public static const ON_CELL_UNFLAGGED:String = 'onCellUnflagged';
		public static const ON_CELL_EXPLODE:String = 'onCellExplode';
		
		private var _cell:MineCell;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	cell
		 */
		public function MineCellEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, cell:MineCell = null) {
			_cell = cell;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone MineCellEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new MineCellEvent(type, bubbles, cancelable, _cell);
		}
		
		/**
		 * Get String format of MineCellEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("MineCellEvent", "type", "bubbles", "cancelable", "eventPhase", "cell"); 
		}
		
		
		/**
		 * @private
		 */
		public function get cell():MineCell {
			return _cell;
		}
	}
}
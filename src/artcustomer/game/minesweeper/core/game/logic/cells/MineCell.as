package artcustomer.game.minesweeper.core.game.logic.cells {
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import artcustomer.maxima.engine.AssetsLoader;
	import artcustomer.maxima.utils.tools.StringTools;
	
	import artcustomer.game.minesweeper.events.MineCellEvent;
	
	[Event(name="onCellSelected", type="artcustomer.game.minesweeper.events.MineCellEvent")]
	[Event(name="onCellOpened", type="artcustomer.game.minesweeper.events.MineCellEvent")]
	[Event(name="onCellFlagged", type="artcustomer.game.minesweeper.events.MineCellEvent")]
	[Event(name="onCellUnflagged", type="artcustomer.game.minesweeper.events.MineCellEvent")]
	[Event(name="onCellExplode", type="artcustomer.game.minesweeper.events.MineCellEvent")]
	
	
	/**
	 * MineCell
	 * 
	 * @author David Massenot
	 */
	public class MineCell extends Sprite {
		private static const SIZE:int = 40;
		
		private var _background:Bitmap;
		private var _cell:Bitmap;
		private var _mine:Bitmap;
		private var _flag:Bitmap;
		private var _text:Bitmap;
		
		private var _row:int;
		private var _column:int;
		
		private var _numAdjacentMines:int;
		
		private var _isMine:Boolean;
		private var _isFlagged:Boolean;
		private var _isOpened:Boolean;
		private var _isDeactivated:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function MineCell(row:int, column:int) {
			_row = row;
			_column = column;
			
			setupBackground();
			setupCell();
			setupMine();
			setupFlag();
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_numAdjacentMines = 0;
			_isMine = false;
			_isFlagged = false;
			_isOpened = false;
			_isDeactivated = false;
		}
		
		//---------------------------------------------------------------------
		//  Background
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupBackground():void {
			_background = new Bitmap(new BitmapData(SIZE, SIZE, false, 0xA97C50));
			
			this.addChild(_background);
		}
		
		/**
		 * @private
		 */
		private function destroyBackground():void {
			this.removeChild(_background);
			
			_background = null;
		}
		
		//---------------------------------------------------------------------
		//  Cell
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupCell():void {
			var bmpSource:Bitmap = AssetsLoader.getInstance().getAssetByName('cell').data;
			
			_cell = new Bitmap(bmpSource.bitmapData.clone());
			
			this.addChild(_cell);
		}
		
		/**
		 * @private
		 */
		private function destroyCell():void {
			this.removeChild(_cell);
			
			_cell = null;
		}
		
		/**
		 * @private
		 */
		private function setCellVisibility(value:Boolean):void {
			_cell.visible = value;
		}
		
		//---------------------------------------------------------------------
		//  Mine
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMine():void {
			var bmpSource:Bitmap = AssetsLoader.getInstance().getAssetByName('cell_mine').data;
			
			_mine = new Bitmap(bmpSource.bitmapData.clone());
			_mine.x = (SIZE - _mine.width) >> 1;
			_mine.y = (SIZE - _mine.height) >> 1;
			
			this.addChild(_mine);
			
		}
		
		/**
		 * @private
		 */
		private function destroyMine():void {
			this.removeChild(_mine);
			
			_mine = null;
		}
		
		/**
		 * @private
		 */
		private function setMineVisibility(value:Boolean):void {
			_mine.visible = value;
		}
		
		//---------------------------------------------------------------------
		//  Flag
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupFlag():void {
			var bmpSource:Bitmap = AssetsLoader.getInstance().getAssetByName('cell_flag').data;
			
			_flag = new Bitmap(bmpSource.bitmapData.clone());
			_flag.x = (SIZE - _flag.width) >> 1;
			_flag.y = (SIZE - _flag.height) >> 1;
			
			this.addChild(_flag);
		}
		
		/**
		 * @private
		 */
		private function destroyFlag():void {
			this.removeChild(_flag);
			
			_flag = null;
		}
		
		/**
		 * @private
		 */
		private function setFlagVisibility(value:Boolean):void {
			_flag.visible = value;
		}
		
		//---------------------------------------------------------------------
		//  Text
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupText(bitmapData:BitmapData):void {
			_text = new Bitmap(bitmapData);
			_text.x = ((SIZE - _text.width) >> 1) - 2;
			_text.y = ((SIZE - _text.height) >> 1) - 2;
			
			this.addChild(_text);
		}
		
		/**
		 * @private
		 */
		private function destroyText():void {
			if (_text) {
				this.removeChild(_text);
				
				_text = null;
			}
		}
		
		/**
		 * @private
		 */
		private function setTextVisibility(value:Boolean):void {
			if (_text) _text.visible = value;
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchCellEvent(type:String):void {
			this.dispatchEvent(new MineCellEvent(type, false, false, this));
		}
		
		
		/**
		 * Get String format of Object.
		 * 
		 * @return
		 */
		override public function toString():String {
			return StringTools.formatToString(this, 'MineCell', 'row', 'column', 'isMine', 'isFlagged');
		}
		
		/**
		 * Destructor.
		 */
		internal function destroy():void {
			destroyFlag();
			destroyCell();
			destroyMine();
			destroyText();
			destroyBackground();
			
			_row = 0;
			_column = 0;
			_numAdjacentMines = 0;
		}
		
		/**
		 * Reset Cell.
		 */
		internal function reset():void {
			init();
			destroyText();
			setCellVisibility(true);
			setFlagVisibility(false);
			setMineVisibility(false);
		}
		
		/**
		 * Select Cell.
		 */
		internal function select():void {
			open();
			
			if (_isMine) {
				setMineVisibility(true);
				dispatchCellEvent(MineCellEvent.ON_CELL_EXPLODE);
			} else {
				dispatchCellEvent(MineCellEvent.ON_CELL_SELECTED);
			}
		}
		
		/**
		 * Open Cell.
		 */
		internal function open():void {
			if (!_isOpened) {
				_isOpened = true;
				
				setCellVisibility(false);
				
				if (!_isMine) {
					setTextVisibility(true);
					dispatchCellEvent(MineCellEvent.ON_CELL_OPENED);
				}
			}
		}
		
		/**
		 * Open Cell.
		 */
		internal function reveal():void {
			if (_isMine) {
				setCellVisibility(false);
				setMineVisibility(true);
			}
		}
		
		/**
		 * Toggle flag on Cell.
		 */
		internal function toggleFlag():void {
			_isFlagged = !_isFlagged;
			
			setFlagVisibility(_isFlagged);
			
			if (_isFlagged) {
				dispatchCellEvent(MineCellEvent.ON_CELL_FLAGGED);
			} else {
				dispatchCellEvent(MineCellEvent.ON_CELL_UNFLAGGED);
			}
		}
		
		/**
		 * Add mine on Cell.
		 */
		internal function addMine():void {
			_isMine = true;
		}
		
		/**
		 * Update adjacent mines
		 */
		internal function updateAdjacentMines(value:int):void {
			_numAdjacentMines = value;
		}
		
		/**
		 * Display adjacent mines value
		 * 
		 * @param	bitmapData
		 */
		internal function displayAdjacentValue(bitmapData:BitmapData):void {
			setupText(bitmapData);
			setTextVisibility(false);
		}
		
		
		/**
		 * @private
		 */
		public function get row():int {
			return _row;
		}
		
		/**
		 * @private
		 */
		public function get column():int {
			return _column;
		}
		
		/**
		 * @private
		 */
		public function get numAdjacentMines():int {
			return _numAdjacentMines;
		}
		
		/**
		 * @private
		 */
		public function get isMine():Boolean {
			return _isMine;
		}
		
		/**
		 * @private
		 */
		public function get isFlagged():Boolean {
			return _isFlagged;
		}
		
		/**
		 * @private
		 */
		public function get isOpened():Boolean {
			return _isOpened;
		}
	}
}
package artcustomer.game.minesweeper.core.game.logic.cells {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.GridFitType;
	import flash.text.AntiAliasType;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.errors.IllegalGameError;
	
	import artcustomer.game.minesweeper.utils.consts.GameFonts;
	
	
	/**
	 * MineCellFactory
	 * 
	 * @author David Massenot
	 */
	public class MineCellFactory extends Object implements IDestroyable {
		private static var __instance:MineCellFactory;
		private static var __allowInstantiation:Boolean;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _stack:Vector.<MineCell>;
		
		private var _numCells:int;
		
		private var _cellColors:Array;
		
		
		/**
		 * Constructor
		 */
		public function MineCellFactory() {
			if (!__allowInstantiation) {
				throw new IllegalGameError(IllegalGameError.E_SINGLETON_CLASS);
				
				return;
			}
			
			setupTextFormat();
			setupTextField();
			setupColors();
			createStack();
		}
		
		//---------------------------------------------------------------------
		//  Text
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTextFormat():void {
			_textFormat = new TextFormat(GameFonts.MAIN_FONT_NAME, 24, 0xFFFFFF);
		}
		
		/**
		 * @private
		 */
		private function destroyTextFormat():void {
			_textFormat = null;
		}
		
		/**
		 * @private
		 */
		private function setupTextField():void {
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.gridFitType = GridFitType.PIXEL;
		}
		
		/**
		 * @private
		 */
		private function destroyTextField():void {
			_textField = null;
		}
		
		/**
		 * @private
		 */
		private function getTextBitmap(value:int):BitmapData {
			var color:uint = 0;
			var bitmapData:BitmapData;
			
			if (value < _cellColors.length) color = _cellColors[value - 1];
			
			_textFormat.color = color;
			_textField.defaultTextFormat = _textFormat;
			_textField.text = value.toString();
			
			bitmapData = new BitmapData(_textField.textWidth, _textField.textHeight, true, 0xFFFFFF);
			bitmapData.draw(_textField);
			
			return bitmapData;
		}
		
		//---------------------------------------------------------------------
		//  Colors
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupColors():void {
			_cellColors = new Array();
			_cellColors.push(0x27AAE1);
			_cellColors.push(0x76FF00);
			_cellColors.push(0xFFE700);
			_cellColors.push(0xFF5B00);
			_cellColors.push(0xED1C24);
			_cellColors.push(0xFF00A2);
			_cellColors.push(0x8B00FF);
			_cellColors.push(0x0500FF);
		}
		
		/**
		 * @private
		 */
		private function destroyColors():void {
			_cellColors.length = 0;
			_cellColors = null;
		}
		
		//---------------------------------------------------------------------
		//  Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createStack():void {
			_stack = new Vector.<MineCell>();
		}
		
		/**
		 * @private
		 */
		private function disposeStack():void {
			var cell:MineCell;
			
			while (_stack.length > 0) {
				_stack.shift().destroy();
			}
		}
		
		/**
		 * @private
		 */
		private function destroyStack():void {
			_stack.length = 0;
			_stack = null;
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeStack();
			destroyStack();
			destroyColors();
			destroyTextField();
			destroyTextFormat();
			
			_numCells = 0;
			
			__instance = null;
			__allowInstantiation = false;
		}
		
		/**
		 * Create MineCell.
		 * 
		 * @param	row
		 * @param	column
		 */
		public function createCell(row:int, column:int):MineCell {
			var cell:MineCell = new MineCell(row, column);
			
			cell.reset();
			
			_stack.push(cell);
			_numCells++;
			
			return cell;
		}
		
		/**
		 * Get cell at index
		 * 
		 * @param	index
		 * @return
		 */
		public function getCellAt(index:int):MineCell {
			if (index < 0 || index >= _numCells) {
				throw new Error('Index is out of bounds !');
				
				return null;
			}
			
			return _stack[index];
		}
		
		/**
		 * Reset all cells
		 */
		public function resetAllCells():void {
			var i:int = 0;
			
			while (i < _stack.length > 0) {
				_stack[i].reset();
				
				i++;
			}
		}
		
		/**
		 * Action when cell is selected
		 * 
		 * @param	cell
		 * @param	onCtrl
		 */
		public function onSelectCell(cell:MineCell, onCtrl:Boolean):void {
			if (!cell.isOpened) {
				if (!onCtrl) {
					if (!cell.isFlagged) {
						cell.select();
					}
				} else {
					cell.toggleFlag();
				}
			}
		}
		
		/**
		 * Open cell.
		 * 
		 * @param	cell
		 */
		public function openCell(cell:MineCell):void {
			cell.open();
		}
		
		/**
		 * Open cell.
		 * 
		 * @param	cell
		 */
		public function revealCell(cell:MineCell):void {
			cell.reveal();
		}
		
		/**
		 * Add mine on cell
		 * 
		 * @param	cell
		 */
		public function addMineOnCell(cell:MineCell):void {
			cell.addMine();
		}
		
		/**
		 * Increase adjacent mines on cell
		 * 
		 * @param	cell
		 * @param	value
		 */
		public function updateAdjacentMinesOnCell(cell:MineCell, value:int):void {
			cell.updateAdjacentMines(value);
			cell.displayAdjacentValue(this.getTextBitmap(value));
		}
		
		/**
		 * Destroy cell.
		 * 
		 * @param	cell
		 */
		public function destroyCell(cell:MineCell):void {
			cell.destroy();
		}
		
		
		/**
		 * Instantiate MineCellFactory.
		 */
		public static function getInstance():MineCellFactory {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new MineCellFactory();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get numCells():int {
			return _numCells;
		}
	}
}
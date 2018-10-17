package artcustomer.game.minesweeper.core.game.logic {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import artcustomer.maxima.core.display.AbstractUIDisplayObject;
	
	import artcustomer.game.minesweeper.core.model.mode.GameDifficultyMode;
	import artcustomer.game.minesweeper.core.game.logic.cells.*;
	import artcustomer.game.minesweeper.events.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	[Event(name="onGameStart", type="artcustomer.game.minesweeper.events.GameLogicEvent")]
	[Event(name="onGameOver", type="artcustomer.game.minesweeper.events.GameLogicEvent")]
	[Event(name="onGameWin", type="artcustomer.game.minesweeper.events.GameLogicEvent")]
	[Event(name="mineCountChange", type="artcustomer.game.minesweeper.events.GameLogicEvent")]
	
	
	/**
	 * DisplayGameLogic
	 * 
	 * @author David Massenot
	 */
	public class DisplayGameLogic extends AbstractUIDisplayObject {
		private var _mineCellFactory:MineCellFactory;
		
		private var _cellStack:Array;
		
		private var _numRows:int;
		private var _numColumns:int;
		private var _numMines:int;
		
		private var _minesCount:int;
		private var _openedCells:int;
		
		private var _isFirstStart:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function DisplayGameLogic() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_numRows = GameDifficultyMode.getInstance().currentMode.rows;
			_numColumns = GameDifficultyMode.getInstance().currentMode.columns;
			_numMines = GameDifficultyMode.getInstance().currentMode.mines;
			_minesCount = _numMines;
			_openedCells = 0;
		}
		
		//---------------------------------------------------------------------
		//  MineCellFactory
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMineCellFactory():void {
			_mineCellFactory = MineCellFactory.getInstance();
		}
		
		/**
		 * @private
		 */
		private function destroyMineCellFactory():void {
			_mineCellFactory.destroy();
			_mineCellFactory = null;
		}
		
		//---------------------------------------------------------------------
		//  Grid
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function createGrid():void {
			var row:int = 0;
			var column:int = 0;
			var total:int = 0;
			var columnStack:Array;
			var cell:MineCell;
			
			_cellStack = new Array();
			
			for (row ; row < _numRows ; row++) {
				columnStack = new Array();
				
				for (column = 0 ; column < _numColumns ; column++) {
					cell = _mineCellFactory.createCell(row, column);
					
					cell.addEventListener(MineCellEvent.ON_CELL_OPENED, handleMineCells, false, 0, true);
					cell.addEventListener(MineCellEvent.ON_CELL_FLAGGED, handleMineCells, false, 0, true);
					cell.addEventListener(MineCellEvent.ON_CELL_UNFLAGGED, handleMineCells, false, 0, true);
					cell.addEventListener(MineCellEvent.ON_CELL_EXPLODE, handleMineCells, false, 0, true);
					
					cell.alpha = 0;
					cell.x = (cell.width + 1) * row;
					cell.y = (cell.height + 1) * column;
					
					this.addChild(cell);
					
					columnStack.push(cell);
					
					TweenLite.to(cell, .5, { alpha : 1, ease : Strong.easeOut, delay : total * 0.01 } );
					
					total++;
				}
				
				_cellStack.push(columnStack);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyGrid():void {
			var i:int = 0;
			var j:int = 0;
			var columns:int = 0;
			var rows:int = _cellStack.length;
			var columnStack:Array;
			var cell:MineCell;
			
			for (i ; i < rows ; i++) {
				columnStack = _cellStack[i];
				columns = columnStack.length;
				
				for (j = 0 ; j < columns ; j++) {
					cell = columnStack[j] as MineCell;
					
					cell.removeEventListener(MineCellEvent.ON_CELL_OPENED, handleMineCells);
					cell.removeEventListener(MineCellEvent.ON_CELL_FLAGGED, handleMineCells);
					cell.removeEventListener(MineCellEvent.ON_CELL_UNFLAGGED, handleMineCells);
					cell.removeEventListener(MineCellEvent.ON_CELL_EXPLODE, handleMineCells);
					
					this.removeChild(cell);
				}
			}
			
			_cellStack.length = 0;
		}
		
		/**
		 * @private
		 */
		private function setMinefield():void {
			var tempMines:int = 0;
			var rand:int;
			var cell:MineCell;
			
			while (tempMines < _numMines) {
				rand = Math.random() * _mineCellFactory.numCells;
				cell = _mineCellFactory.getCellAt(rand);
				
				if (!cell.isMine) {
					_mineCellFactory.addMineOnCell(cell);
					
					tempMines++;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function setAdjacentValues():void {
			var i:int = 0;
			var j:int = 0;
			var length:int = _mineCellFactory.numCells;
			var value:int;
			var cell:MineCell;
			var adjacentCell:MineCell;
			var adjacentCells:Array;
			var adjacentCellLength:int;
			
			for (i ; i < length ; i++) {
				cell = _mineCellFactory.getCellAt(i);
				value = 0;
				adjacentCells = getAdjacentCells(cell);
				adjacentCellLength = adjacentCells.length;
				j = 0;
				
				for (j ; j < adjacentCellLength ; j++) {
					adjacentCell = adjacentCells[j] as MineCell;
					
					if (adjacentCell.isMine) value++;
				}
				
				if (value != 0) _mineCellFactory.updateAdjacentMinesOnCell(cell, value);
			}
		}
		
		/**
		 * @private
		 */
		private function getAdjacentCells(cell:MineCell):Array {
			var cells:Array = new Array();
			
			if (cell.row == 0) {
				cells.push(_cellStack[cell.row + 1][cell.column]);
				
				if (cell.column == 0) {
					cells.push(_cellStack[cell.row][cell.column + 1]);
					cells.push(_cellStack[cell.row + 1][cell.column + 1]);
				} else if (cell.column == (_numColumns - 1)) {
					cells.push(_cellStack[cell.row][cell.column - 1]);
					cells.push(_cellStack[cell.row + 1][cell.column - 1]);
				} else {
					cells.push(_cellStack[cell.row][cell.column - 1]);
					cells.push(_cellStack[cell.row][cell.column + 1]);
					cells.push(_cellStack[cell.row + 1][cell.column - 1]);
					cells.push(_cellStack[cell.row + 1][cell.column + 1]);
				}
			} else if (cell.row == (_numRows - 1)) {
				cells.push(_cellStack[cell.row - 1][cell.column]);
				
				if (cell.column == 0) {
					cells.push(_cellStack[cell.row - 1][cell.column + 1]);
					cells.push(_cellStack[cell.row][cell.column + 1]);
				} else if (cell.column == (_numColumns - 1)) {
					cells.push(_cellStack[cell.row - 1][cell.column - 1]);
					cells.push(_cellStack[cell.row][cell.column - 1]);
				} else {
					cells.push(_cellStack[cell.row - 1][cell.column - 1]);
					cells.push(_cellStack[cell.row - 1][cell.column + 1]);
					cells.push(_cellStack[cell.row][cell.column - 1]);
					cells.push(_cellStack[cell.row][cell.column + 1]);
				}
			} else {
				cells.push(_cellStack[cell.row - 1][cell.column]);
				cells.push(_cellStack[cell.row + 1][cell.column]);
				
				if (cell.column == 0) {
					cells.push(_cellStack[cell.row - 1][cell.column + 1]);
					cells.push(_cellStack[cell.row][cell.column + 1]);
					cells.push(_cellStack[cell.row + 1][cell.column + 1]);
				} else if (cell.column == (_numColumns - 1)) {
					cells.push(_cellStack[cell.row - 1][cell.column - 1]);
					cells.push(_cellStack[cell.row][cell.column - 1]);
					cells.push(_cellStack[cell.row + 1][cell.column - 1]);
				} else {
					cells.push(_cellStack[cell.row - 1][cell.column - 1]);
					cells.push(_cellStack[cell.row - 1][cell.column + 1]);
					cells.push(_cellStack[cell.row][cell.column - 1]);
					cells.push(_cellStack[cell.row][cell.column + 1]);
					cells.push(_cellStack[cell.row + 1][cell.column - 1]);
					cells.push(_cellStack[cell.row + 1][cell.column + 1]);
				}
			}
			
			return cells;
		}
		
		/**
		 * @private
		 */
		private function hasAdjacentValue(row:int, column:int):Boolean {
			if (row >= _numRows || column >= _numColumns) return false;
			
			return true;
		}
		
		/**
		 * @private
		 */
		private function openAdjacentCells(cell:MineCell):void {
			var cells:Array = getAdjacentCells(cell);
			var adjacentCell:MineCell;
			var i:int;
			var length:int = cells.length;
			
			for (i ; i < length ; i++) {
				adjacentCell = cells[i] as MineCell;
				
				_mineCellFactory.openCell(adjacentCell);
			}
		}
		
		/**
		 * @private
		 */
		private function revealAllMines():void {
			var i:int;
			var length:int = _mineCellFactory.numCells;
			var cell:MineCell;
			
			for (i ; i < length ; i++) {
				cell = _mineCellFactory.getCellAt(i);
				
				if (cell.isMine) _mineCellFactory.revealCell(cell);
			}
		}
		
		/**
		 * @private
		 */
		private function countOpenedCells():void {
			if (_openedCells == (_numColumns * _numRows) - _numMines) this.gameOver(true);
		}
		
		//---------------------------------------------------------------------
		//  Grid
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleMineCells(e:MineCellEvent):void {
			switch (e.type) {
				case('onCellOpened'):
					if (e.cell.numAdjacentMines == 0) openAdjacentCells(e.cell);
					
					_openedCells++;
					
					countOpenedCells();
					break;
					
				case('onCellFlagged'):
					_minesCount--;
					
					dispatchGameEvent(GameLogicEvent.MINE_COUNT_CHANGE);
					break;
					
				case('onCellUnflagged'):
					_minesCount++;
					
					dispatchGameEvent(GameLogicEvent.MINE_COUNT_CHANGE);
					break;
					
				case('onCellExplode'):
					playSound(this.context.instance.assetsPath + 'sounds/explosion.mp3');
					revealAllMines();
					gameOver(false);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			this.addEventListener(MouseEvent.CLICK, handleMouse, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			this.removeEventListener(MouseEvent.CLICK, handleMouse);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleMouse(e:MouseEvent):void {
			switch (e.type) {
				case('click'):
					_mineCellFactory.onSelectCell(e.target as MineCell, e.ctrlKey);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Game Over
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onGameOver():void {
			unlistenEvents();
		}
		
		//---------------------------------------------------------------------
		//  Sound
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function initSound():void {
			this.context.instance.sfxEngine.setVolume(.5);
		}
		
		/**
		 * @private
		 */
		private function playSound(stream:String):void {
			this.context.instance.sfxEngine.playStreamOnChannel(stream);
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchGameEvent(type:String):void {
			this.dispatchEvent(new GameLogicEvent(type, false, false, _minesCount));
		}
		
		
		/**
		 * Start
		 */
		public function start():void {
			if (!_isFirstStart) {
				_isFirstStart = true;
				
				initSound();
			} else {
				_mineCellFactory.resetAllCells();
			}
			
			listenEvents();
			init();
			setMinefield();
			setAdjacentValues();
			dispatchGameEvent(GameLogicEvent.ON_GAME_START);
		}
		
		/**
		 * Game over
		 */
		public function gameOver(win:Boolean = false):void {
			onGameOver();
			
			if (win) {
				dispatchGameEvent(GameLogicEvent.ON_GAME_WIN);
			} else {
				dispatchGameEvent(GameLogicEvent.ON_GAME_OVER);
			}
		}
		
		/**
		 * Entry point.
		 */
		override public function setup():void {
			super.setup();
			
			init();
			setupMineCellFactory();
			createGrid();
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			unlistenEvents();
			destroyGrid();
			destroyMineCellFactory();
			
			_numRows = 0;
			_numColumns = 0;
			_numMines = 0;
			
			super.destroy();
		}
	}
}
package artcustomer.game.minesweeper.core.game {
	import flash.ui.Keyboard;
	
	import artcustomer.maxima.core.game.DisplayGame;
	import artcustomer.maxima.engine.inputs.controls.IGameControl;
	import artcustomer.maxima.engine.inputs.controls.table.builder.ControlTableBuilder;
	import artcustomer.maxima.utils.consts.ControlType;
	
	import artcustomer.game.minesweeper.core.model.mode.GameDifficultyMode;
	import artcustomer.game.minesweeper.core.game.timer.*;
	import artcustomer.game.minesweeper.core.game.logic.*;
	import artcustomer.game.minesweeper.core.game.hud.*;
	import artcustomer.game.minesweeper.events.*;
	import artcustomer.game.minesweeper.utils.consts.*;
	
	
	/**
	 * MineSweeperDisplayGame
	 * 
	 * @author David Massenot
	 */
	public class MineSweeperDisplayGame extends DisplayGame {
		private var _gameDifficultyMode:GameDifficultyMode;
		private var _gameTimer:GameTimer;
		private var _displayGameLogic:DisplayGameLogic;
		private var _displayGameHUD:DisplayGameHUD;
		
		
		/**
		 * Constructor
		 */
		public function MineSweeperDisplayGame() {
			super(CoreElements.MINESWEEPER_DISPLAYGAME);
		}
		
		//---------------------------------------------------------------------
		//  GameDifficultyMode
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupGameDifficultyMode():void {
			_gameDifficultyMode = GameDifficultyMode.getInstance();
			
			_gameDifficultyMode.addMode('Easy', 'easy', 7, 7, 10);
			_gameDifficultyMode.addMode('Intermediate', 'intermediate', 10, 10, 20);
			_gameDifficultyMode.addMode('Hard', 'hard', 16, 12, 30);
			_gameDifficultyMode.setMode(this.context.instance.shore.get(ShoreProperties.GAME_DIFFICULTY));
		}
		
		/**
		 * @private
		 */
		private function destroyGameDifficultyMode():void {
			_gameDifficultyMode.destroy();
			_gameDifficultyMode = null;
		}
		
		//---------------------------------------------------------------------
		//  GameTimer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupGameTimer():void {
			_gameTimer = new GameTimer(1000, GameUtils.GAME_TIME_LIMIT);
			_gameTimer.addEventListener(GameTimerEvent.ON_TICK, handleGameTimer, false, 0, true);
			_gameTimer.addEventListener(GameTimerEvent.ON_TIME_LIMIT, handleGameTimer, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyGameTimer():void {
			_gameTimer.removeEventListener(GameTimerEvent.ON_TICK, handleGameTimer);
			_gameTimer.removeEventListener(GameTimerEvent.ON_TIME_LIMIT, handleGameTimer);
			_gameTimer.destroy();
			_gameTimer = null;
		}
		
		/**
		 * @private
		 */
		private function handleGameTimer(e:GameTimerEvent):void {
			switch (e.type) {
				case(GameTimerEvent.ON_TICK):
					_displayGameHUD.updateTime(e.tick);
					break;
					
				case(GameTimerEvent.ON_TIME_LIMIT):
					_displayGameLogic.gameOver();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  DisplayGameLogic
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDisplayGameLogic():void {
			_displayGameLogic = new DisplayGameLogic();
			_displayGameLogic.addEventListener(GameLogicEvent.ON_GAME_START, handleGameLogic, false, 0, true);
			_displayGameLogic.addEventListener(GameLogicEvent.ON_GAME_OVER, handleGameLogic, false, 0, true);
			_displayGameLogic.addEventListener(GameLogicEvent.ON_GAME_WIN, handleGameLogic, false, 0, true);
			_displayGameLogic.addEventListener(GameLogicEvent.MINE_COUNT_CHANGE, handleGameLogic, false, 0, true);
			
			this.addUIChild(_displayGameLogic);
		}
		
		/**
		 * @private
		 */
		private function destroyDisplayGameLogic():void {
			_displayGameLogic.removeEventListener(GameLogicEvent.ON_GAME_START, handleGameLogic);
			_displayGameLogic.removeEventListener(GameLogicEvent.ON_GAME_OVER, handleGameLogic);
			_displayGameLogic.removeEventListener(GameLogicEvent.ON_GAME_WIN, handleGameLogic);
			_displayGameLogic.removeEventListener(GameLogicEvent.MINE_COUNT_CHANGE, handleGameLogic);
			
			this.removeUIChild(_displayGameLogic);
			
			_displayGameLogic = null;
		}
		
		/**
		 * @private
		 */
		private function moveDisplayGameLogic():void {
			if (_displayGameLogic) {
				_displayGameLogic.x = (this.context.contextWidth - _displayGameLogic.width) >> 1;
				_displayGameLogic.y = (this.context.contextHeight - _displayGameLogic.height) >> 1;
			}
		}
		
		/**
		 * @private
		 */
		private function handleGameLogic(e:GameLogicEvent):void {
			switch (e.type) {
				case(GameLogicEvent.ON_GAME_START):
					_gameTimer.stop();
					_gameTimer.start();
					_displayGameHUD.removeGameOver();
					_displayGameHUD.updateTime(0);
					_displayGameHUD.updateMineCount(e.mineCount);
					_displayGameHUD.updateDifficultyMode(_gameDifficultyMode.currentMode.name);
					break;
					
				case(GameLogicEvent.ON_GAME_OVER):
					//this.context.instance.sfxEngine.playStream('assets/sounds/explosion.mp3');
					_displayGameHUD.displayGameOver(false);
					_gameTimer.stop();
					break;
					
				case(GameLogicEvent.ON_GAME_WIN):
					_displayGameHUD.displayGameOver(true);
					_displayGameHUD.updateMineCount(0);
					_gameTimer.stop();
					break;
					
				case(GameLogicEvent.MINE_COUNT_CHANGE):
					_displayGameHUD.updateMineCount(e.mineCount);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  DisplayGameHUD
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupDisplayGameHUD():void {
			_displayGameHUD = new DisplayGameHUD();
			_displayGameHUD.addEventListener(GameHUDEvent.ON_PRESS_RESTART, handleGameHUD, false, 0, true);
			_displayGameHUD.addEventListener(GameHUDEvent.ON_PRESS_QUIT, handleGameHUD, false, 0, true);
			
			this.addUIChild(_displayGameHUD);
		}
		
		/**
		 * @private
		 */
		private function destroyDisplayGameHUD():void {
			_displayGameHUD.removeEventListener(GameHUDEvent.ON_PRESS_RESTART, handleGameHUD);
			_displayGameHUD.removeEventListener(GameHUDEvent.ON_PRESS_QUIT, handleGameHUD);
			
			this.removeUIChild(_displayGameHUD);
			
			_displayGameHUD = null;
		}
		
		/**
		 * @private
		 */
		private function moveDisplayGameHUD():void {
			if (_displayGameHUD) {
				_displayGameHUD.x = (this.context.contextWidth - _displayGameHUD.width) >> 1;
				_displayGameHUD.y = 20;
			}
		}
		
		/**
		 * @private
		 */
		private function handleGameHUD(e:GameHUDEvent):void {
			switch (e.type) {
				case(GameHUDEvent.ON_PRESS_RESTART):
					_displayGameLogic.start();
					break;
					
				case(GameHUDEvent.ON_PRESS_QUIT):
					this.context.instance.gameEngine.navigationSystem.timelineBack();
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Entry point.
		 */
		override protected function onEntry():void {
			super.onEntry();
			
			setupGameDifficultyMode();
			setupGameTimer();
			setupDisplayGameLogic();
			setupDisplayGameHUD();
			
			this.start();
			this.resize();
		}
		
		/**
		 * Exit point.
		 */
		override protected function onExit():void {
			super.onExit();
		}
		
		/**
		 * Destructor.
		 */
		override protected function destroy():void {
			destroyDisplayGameHUD();
			destroyDisplayGameLogic();
			destroyGameTimer();
			destroyGameDifficultyMode();
			
			super.destroy();
		}
		
		/**
		 * Start Game.
		 */
		override protected function start():void {
			_displayGameLogic.start();
		}
		
		/**
		 * Resize Game.
		 */
		override protected function resize():void {
			moveDisplayGameLogic();
			moveDisplayGameHUD();
		}
	}
}
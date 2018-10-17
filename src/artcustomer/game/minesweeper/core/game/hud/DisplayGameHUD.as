package artcustomer.game.minesweeper.core.game.hud {
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import artcustomer.maxima.core.display.AbstractUIDisplayObject;
	
	import artcustomer.game.minesweeper.core.model.mode.GameDifficultyMode;
	import artcustomer.game.minesweeper.core.game.hud.time.UIClock;
	import artcustomer.game.minesweeper.core.game.hud.mine.UIMineCounter;
	import artcustomer.game.minesweeper.core.game.hud.difficulty.UIDifficultyViewer;
	import artcustomer.game.minesweeper.display.ui.controls.buttons.TextButton;
	import artcustomer.game.minesweeper.events.GameHUDEvent;
	
	[Event(name="onPressRestart", type="artcustomer.game.minesweeper.events.GameHUDEvent")]
	[Event(name="onPressQuit", type="artcustomer.game.minesweeper.events.GameHUDEvent")]
	
	
	/**
	 * DisplayGameHUD
	 * 
	 * @author David Massenot
	 */
	public class DisplayGameHUD extends AbstractUIDisplayObject {
		private var _uiClock:UIClock;
		private var _uiMineCounter:UIMineCounter;
		private var _uiDifficultyViewer:UIDifficultyViewer;
		private var _restartButton:TextButton;
		private var _quitButton:TextButton;
		
		private var _gameOverDisplay:Bitmap;
		
		
		/**
		 * Constructor
		 */
		public function DisplayGameHUD() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  UIClock
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupUIClock():void {
			_uiClock = new UIClock();
			_uiClock.x = 0;
			_uiClock.y = 0;
			
			this.addChild(_uiClock);
		}
		
		/**
		 * @private
		 */
		private function destroyUIClock():void {
			this.removeChild(_uiClock);
			
			_uiClock.destroy();
			_uiClock = null;
		}
		
		//---------------------------------------------------------------------
		//  UIMineCounter
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupUIMineCounter():void {
			_uiMineCounter = new UIMineCounter();
			_uiMineCounter.x = 200;
			_uiMineCounter.y = 0;
			
			this.addChild(_uiMineCounter);
		}
		
		/**
		 * @private
		 */
		private function destroyUIMineCounter():void {
			this.removeChild(_uiMineCounter);
			
			_uiMineCounter.destroy();
			_uiMineCounter = null;
		}
		
		//---------------------------------------------------------------------
		//  UIDifficultyViewer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupUIDifficultyViewer():void {
			_uiDifficultyViewer = new UIDifficultyViewer();
			_uiDifficultyViewer.x = 400;
			_uiDifficultyViewer.y = 0;
			
			this.addChild(_uiDifficultyViewer);
		}
		
		/**
		 * @private
		 */
		private function destroyUIDifficultyViewer():void {
			this.removeChild(_uiDifficultyViewer);
			
			_uiDifficultyViewer.destroy();
			_uiDifficultyViewer = null;
		}
		
		//---------------------------------------------------------------------
		//  RestartButton
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupRestartButton():void {
			_restartButton = new TextButton('Restart');
			_restartButton.addEventListener(TextButton.ON_BUTTON_SELECT, handleRestartButton, false, 0, true);
			_restartButton.y = this.context.contextHeight - _restartButton.height - 30;
			
			this.addChild(_restartButton);
		}
		
		/**
		 * @private
		 */
		private function destroyRestartButton():void {
			this.removeChild(_restartButton);
			
			_restartButton.removeEventListener(TextButton.ON_BUTTON_SELECT, handleRestartButton);
			_restartButton.destroy();
			_restartButton = null;
		}
		
		/**
		 * @private
		 */
		private function handleRestartButton(e:Event):void {
			switch (e.type) {
				case(TextButton.ON_BUTTON_SELECT):
					dispatchHUDEvent(GameHUDEvent.ON_PRESS_RESTART);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  QuitButton
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupQuitButton():void {
			_quitButton = new TextButton('Quit');
			_quitButton.addEventListener(TextButton.ON_BUTTON_SELECT, handleQuitButton, false, 0, true);
			_quitButton.x = 100;
			_quitButton.y = this.context.contextHeight - _quitButton.height - 30;
			
			this.addChild(_quitButton);
		}
		
		/**
		 * @private
		 */
		private function destroyQuitButton():void {
			this.removeChild(_quitButton);
			
			_quitButton.removeEventListener(TextButton.ON_BUTTON_SELECT, handleQuitButton);
			_quitButton.destroy();
			_quitButton = null;
		}
		
		/**
		 * @private
		 */
		private function handleQuitButton(e:Event):void {
			switch (e.type) {
				case(TextButton.ON_BUTTON_SELECT):
					dispatchHUDEvent(GameHUDEvent.ON_PRESS_QUIT);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Game Over Display
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupGameOverDisplay():void {
			if (_gameOverDisplay) {
				_gameOverDisplay.x = (this.width - _gameOverDisplay.width) >> 1;
				_gameOverDisplay.y = (this.height - _gameOverDisplay.height) >> 1;
				
				this.addChild(_gameOverDisplay);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyGameOverDisplay():void {
			if (_gameOverDisplay) {
				this.removeChild(_gameOverDisplay);
				
				_gameOverDisplay = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Tools
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function getTimeFormat(time:int):String {
			var stringTime:String = time.toString();
			var formatedTime:String = '';
			var charsLength:int = 2;
			
			if (stringTime.length < charsLength) {
				formatedTime = '0' + stringTime;
			} else {
				formatedTime = stringTime.toString();
			}
			
			return formatedTime;
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchHUDEvent(type:String):void {
			this.dispatchEvent(new GameHUDEvent(type, false, false));
		}
		
		
		/**
		 * Entry point.
		 */
		override public function setup():void {
			super.setup();
			
			setupUIClock();
			setupUIMineCounter();
			setupUIDifficultyViewer();
			setupRestartButton();
			setupQuitButton();
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			destroyQuitButton();
			destroyRestartButton();
			destroyUIDifficultyViewer();
			destroyUIMineCounter();
			destroyUIClock();
			destroyGameOverDisplay();
			
			super.destroy();
		}
		
		
		/**
		 * Update Time.
		 * 
		 * @param	tick
		 */
		public function updateTime(tick:int):void {
			var seconds:int = int(tick % 60);
			var minutes:int = int((tick / 60) % 60);
			var formatedTime:String = getTimeFormat(minutes) + ':' + getTimeFormat(seconds);
			
			_uiClock.updateTime(formatedTime);
		}
		
		/**
		 * Update mine count.
		 * 
		 * @param	value
		 */
		public function updateMineCount(value:int):void {
			_uiMineCounter.updateMineValue(value);
		}
		
		/**
		 * Update difficulty value.
		 * 
		 * @param	value
		 */
		public function updateDifficultyMode(value:String):void {
			_uiDifficultyViewer.updateDifficulty(value);
		}
		
		/**
		 * Display game over.
		 */
		public function displayGameOver(win:Boolean):void {
			var asset:String;
			
			if (win) {
				asset = 'game_win';
			} else {
				asset = 'game_lose';
			}
			
			_gameOverDisplay = this.context.instance.assetsLoader.getAssetByName(asset).data;
			
			setupGameOverDisplay();
		}
		
		/**
		 * Remove game over.
		 */
		public function removeGameOver():void {
			destroyGameOverDisplay();
		}
	}
}
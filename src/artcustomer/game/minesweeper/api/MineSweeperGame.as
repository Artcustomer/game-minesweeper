package artcustomer.game.minesweeper.api {
	import artcustomer.maxima.context.FlashGameContext;
	import artcustomer.maxima.events.*;
	import artcustomer.maxima.debug.stats.StatsManager;
	import artcustomer.maxima.utils.consts.*;
	import artcustomer.maxima.entities.model.ScoreModel;
	import artcustomer.maxima.entities.command.ScoreCommand;
	
	import artcustomer.game.minesweeper.core.loader.GameAssetsLoader;
	import artcustomer.game.minesweeper.core.view.MainMenuView;
	import artcustomer.game.minesweeper.core.game.*;
	import artcustomer.game.minesweeper.utils.consts.*;
	
	
	/**
	 * MineSweeperGame
	 * 
	 * @author David Massenot
	 */
	public class MineSweeperGame extends FlashGameContext {
		
		
		/**
		 * Constructor
		 */
		public function MineSweeperGame() {
			super();
			
			this.contextWidth = GameUtils.GAME_SCREEN_WIDTH;
			this.contextHeight = GameUtils.GAME_SCREEN_HEIGHT;
			this.name = GameUtils.GAME_NAME;
			this.mode = GameMode.DEV;
			this.assetsPath = GameAssetsPath.ASSETS_PATH;
			this.scaleToStage = false;
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenEvents():void {
			this.addEventListener(GameEvent.GAME_FOCUS_IN, handleGame, false, 0, true);
			this.addEventListener(GameEvent.GAME_FOCUS_OUT, handleGame, false, 0, true);
			this.addEventListener(GameErrorEvent.ERROR, handleGameError, false, 0, true);
			this.addEventListener(GameErrorEvent.GAME_ERROR, handleGameError, false, 0, true);
			this.addEventListener(GameErrorEvent.ILLEGAL_ERROR, handleGameError, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenEvents():void {
			this.removeEventListener(GameEvent.GAME_FOCUS_IN, handleGame);
			this.removeEventListener(GameEvent.GAME_FOCUS_OUT, handleGame);
			this.removeEventListener(GameErrorEvent.ERROR, handleGameError);
			this.removeEventListener(GameErrorEvent.GAME_ERROR, handleGameError);
			this.removeEventListener(GameErrorEvent.ILLEGAL_ERROR, handleGameError);
		}
		
		/**
		 * @private
		 */
		private function handleGame(e:GameEvent):void {
			switch (e.type) {
				case(GameEvent.GAME_FOCUS_IN):
					break;
					
				case(GameEvent.GAME_FOCUS_OUT):
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleGameError(e:GameErrorEvent):void {
			var allowError:Boolean = true;
			var errorName:String = e.errorName +  ' ' + e.error.errorID;
			var errorText:String = '';
			
			switch (this.mode) {
				case(GameMode.RELEASE):
					allowError = true;
					errorText = String(e.error.message);
					break;
					
				case(GameMode.DEV):
					allowError = true;
					errorText = String(e.error.getStackTrace());
					break;
					
				case(GameMode.DEBUG):
					allowError = true;
					errorText = String(e.error.getStackTrace());
					break;
					
				default:
					allowError = false;
					break;
			}
			
			if (allowError) this.sendExternalMessage(errorText, errorName);
			
			e.stopPropagation();
		}
		
		
		/**
		 * Called when framework is ready
		 */
		override protected function onReady():void {
			this.flashGameEngine.setGlobalLoader(GameAssetsLoader, CoreElements.GLOBAL_LOADER);
			this.flashGameEngine.addView(MainMenuView, CoreElements.VIEW_MAINMENU);
			this.flashGameEngine.setGame(MineSweeperDisplayGame, CoreElements.MINESWEEPER_DISPLAYGAME);
			
			this.logicEngine.addModel(ScoreModel);
			this.logicEngine.addCommand(ScoreCommand);
			
			this.start();
		}
		
		/**
		 * Entry point.
		 */
		override public function setup():void {
			//var stats:StatsManager = StatsManager.getInstance();
			//stats.stageReference = this.stageReference;
			//stats.init();
			
			listenEvents();
			
			super.setup();
			
			this.moveLogo(LogoPosition.BOTTOM_RIGHT, 5, 5);
			this.shore.put(GameUtils.GAME_DEFAULT_LANGUAGE, ShoreProperties.LANGUAGE);
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			unlistenEvents();
			
			super.destroy();
		}
		
		/**
		 * Send external message from internal elements of the framework.
		 * 
		 * @param	message
		 * @param	id
		 */
		override public function sendExternalMessage(message:String, id:String = null):void {
			trace(String(id), message);
		}
	}
}
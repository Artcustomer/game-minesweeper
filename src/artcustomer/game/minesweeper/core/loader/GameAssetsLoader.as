package artcustomer.game.minesweeper.core.loader {
	import artcustomer.maxima.core.loader.GlobalLoader;
	import artcustomer.maxima.events.AssetsLoaderEvent;
	import artcustomer.maxima.extensions.display.ui.preloader.PreloadBar;
	
	import artcustomer.game.minesweeper.utils.consts.CoreElements;
	
	
	/**
	 * GameAssetsLoader
	 * 
	 * @author David Massenot
	 */
	public class GameAssetsLoader extends GlobalLoader {
		private static const ASSETS_DESCRIPTION:String = 'loading assets';
		
		private var _preloadBar:PreloadBar;
		
		
		/**
		 * Constructor
		 */
		public function GameAssetsLoader() {
			super(CoreElements.GLOBAL_LOADER);
			
			_isAvailableForHistory = false;
		}
		
		//---------------------------------------------------------------------
		//  PreloadBar
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupPreloadBar():void {
			_preloadBar = new PreloadBar(400, 2, 0x726658, 0xA97C50, 0x000000);
			
			this.displayContainer.addChild(_preloadBar);
		}
		
		/**
		 * @private
		 */
		private function destroyPreloadBar():void {
			if (_preloadBar) {
				this.displayContainer.removeChild(_preloadBar);
				
				_preloadBar.destroy();
				_preloadBar = null;	
			}
		}
		
		/**
		 * @private
		 */
		private function updatePreloadBar(progress:Number):void {
			if (_preloadBar) _preloadBar.updateProgress(progress);
		}
		
		/**
		 * @private
		 */
		private function movePreloadBar():void {
			if (_preloadBar) {
				_preloadBar.x = (this.context.contextWidth - _preloadBar.width) >> 1;
				_preloadBar.y = (this.context.contextHeight - _preloadBar.height) >> 1;
			}
		}
		
		//---------------------------------------------------------------------
		//  Assets
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function loadAssets():void {
			this.queueAsset('assets/images/game_logo.png', 'game_logo', 'logos');
			this.queueAsset('assets/images/cell.png', 'cell', 'game_assets');
			this.queueAsset('assets/images/cell_flag.png', 'cell_flag', 'game_assets');
			this.queueAsset('assets/images/cell_mine.png', 'cell_mine', 'game_assets');
			this.queueAsset('assets/images/mine.png', 'mine_small', 'ui_assets');
			this.queueAsset('assets/images/clock.png', 'clock_small', 'ui_assets');
			this.queueAsset('assets/images/flag.png', 'flag_small', 'ui_assets');
			this.queueAsset('assets/images/game-over_lose.png', 'game_lose', 'ui_game');
			this.queueAsset('assets/images/game-over_win.png', 'game_win', 'ui_game');
			this.queueAsset('assets/sounds/explosion.mp3', 'explosion', 'sounds');
			this.queueAsset('assets/xml/menu-main.xml', 'mainmenu', 'xml');
			this.load(ASSETS_DESCRIPTION);
		}
		
		//---------------------------------------------------------------------
		//  Navigation
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function goForward():void {
			trace('goForward');
			this.context.instance.gameEngine.navigationSystem.timelineForward();
		}
		
		
		/**
		 * AssetsLoaderEvent.LOADING_PROGRESS Callback.
		 * 
		 * @param	e
		 */
		override protected function onProgressLoading(e:AssetsLoaderEvent):void {
			updatePreloadBar(e.progress);
		}
		
		/**
		 * AssetsLoaderEvent.LOADING_ERROR Callback.
		 * 
		 * @param	e
		 */
		override protected function onErrorLoading(e:AssetsLoaderEvent):void {
			updatePreloadBar(0);
			
			this.context.instance.sendExternalMessage(e.error, 'Assets loading error');
		}
		
		/**
		 * AssetsLoaderEvent.LOADING_PROGRESS Callback.
		 * 
		 * @param	e
		 */
		override protected function onCompleteLoading(e:AssetsLoaderEvent):void {
			trace(e);
			
			switch (e.description) {
				case(ASSETS_DESCRIPTION):
					goForward();
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
			
			setupPreloadBar();
			loadAssets();
			
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
			destroyPreloadBar();
			
			super.destroy();
		}
		
		/**
		 * Resize.
		 */
		override protected function resize():void {
			movePreloadBar();
		}
	}
}
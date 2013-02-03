package artcustomer.game.minesweeper.core.view {
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	
	import artcustomer.maxima.core.view.DisplayView;
	import artcustomer.maxima.engine.inputs.controls.IGameControl;
	import artcustomer.maxima.engine.inputs.controls.table.builder.ControlTableBuilder;
	import artcustomer.maxima.utils.consts.ControlType;
	import artcustomer.maxima.extensions.events.MenuListEvent;
	
	import artcustomer.game.minesweeper.core.model.vo.MainMenuValueObject;
	import artcustomer.game.minesweeper.display.ui.menu.MainMenu;
	import artcustomer.game.minesweeper.utils.consts.*;
	
	
	/**
	 * MainMenuView
	 * 
	 * @author David Massenot
	 */
	public class MainMenuView extends DisplayView {
		private var _logo:Bitmap;
		
		private var _mainMenu:MainMenu;
		
		
		/**
		 * Constructor
		 */
		public function MainMenuView() {
			super(CoreElements.VIEW_MAINMENU);
		}
		
		//---------------------------------------------------------------------
		//  Controls
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setControls():void {
			var builder:ControlTableBuilder = new ControlTableBuilder();
			
			builder.addControl(ControlType.KEYBOARD, Keyboard.SPACE.toString());
			
			this.mapControl(ControlActions.VALIDATE_MENU, builder.assemble());
			
			builder.clear();
			builder.addControl(ControlType.KEYBOARD, Keyboard.UP.toString());
			builder.addControl(ControlType.KEYBOARD, Keyboard.DOWN.toString());
			
			this.mapControl(ControlActions.NAVIGATE_MENU, builder.assemble());
			
			builder.destroy();
		}
		
		//---------------------------------------------------------------------
		//  Logo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLogo():void {
			_logo = this.context.instance.assetsLoader.getAssetByName('game_logo').data;
			
			this.displayContainer.addChild(_logo);
		}
		
		/**
		 * @private
		 */
		private function destroyLogo():void {
			this.displayContainer.removeChild(_logo);
			
			_logo = null;
		}
		
		/**
		 * @private
		 */
		private function moveLogo():void {
			if (_logo) {
				_logo.x = (this.context.contextWidth - _logo.width) >> 1;
				_logo.y = 50;
			}
		}
		
		//---------------------------------------------------------------------
		//  MainMenu
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupMainMenu():void {
			_mainMenu = new MainMenu(this.context.instance.assetsLoader.getAssetByName('mainmenu').data);
			_mainMenu.addEventListener(MenuListEvent.ON_SELECT_ITEM, handleMainMenu, false, 0, true);
			
			this.displayContainer.addChild(_mainMenu);
		}
		
		/**
		 * @private
		 */
		private function destroyMainMenu():void {
			this.displayContainer.removeChild(_mainMenu);
			
			_mainMenu.removeEventListener(MenuListEvent.ON_SELECT_ITEM, handleMainMenu);
			_mainMenu.destroy();
			_mainMenu = null
		}
		
		/**
		 * @private
		 */
		private function moveMainMenu():void {
			if (_mainMenu) {
				_mainMenu.x = (this.context.contextWidth - _mainMenu.width) >> 1;
				_mainMenu.y = (this.context.contextHeight - _mainMenu.height) >> 1;
			}
		}
		
		/**
		 * @private
		 */
		private function selectMainMenu():void {
			if (_mainMenu) _mainMenu.select();
		}
		
		/**
		 * @private
		 */
		private function focusNextMainMenu():void {
			if (_mainMenu) _mainMenu.focusNext();
		}
		
		/**
		 * @private
		 */
		private function focusPreviousMainMenu():void {
			if (_mainMenu) _mainMenu.focusPrevious();
		}
		
		/**
		 * @private
		 */
		private function handleMainMenu(e:MenuListEvent):void {
			switch (e.type) {
				case('onSelectItem'):
					this.context.instance.shore.remove(ShoreProperties.GAME_DIFFICULTY);
					this.context.instance.shore.put((e.valueObject as MainMenuValueObject).difficulty, ShoreProperties.GAME_DIFFICULTY);
					
					goForward();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Navigation
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function goForward():void {
			this.context.instance.gameEngine.navigationSystem.timelineForward();
		}
		
		
		/**
		 * On control pressed.
		 * 
		 * @param	control
		 */
		override protected function onControlPressed(control:IGameControl):void {
			switch (control.action) {
				case(ControlActions.NAVIGATE_MENU):
					if (control.inputCode == Keyboard.UP.toString()) focusPreviousMainMenu();
					if (control.inputCode == Keyboard.DOWN.toString()) focusNextMainMenu();
					break;
					
				case(ControlActions.VALIDATE_MENU):
					selectMainMenu();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * On control repeated.
		 * 
		 * @param	control
		 */
		override protected function onControlRepeated(control:IGameControl):void {
			switch (control.action) {
				case(ControlActions.NAVIGATE_MENU):
					if (control.inputCode == Keyboard.UP.toString()) focusPreviousMainMenu();
					if (control.inputCode == Keyboard.DOWN.toString()) focusNextMainMenu();
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
			
			setupLogo();
			setupMainMenu();
			setControls();
			
			this.resize();
		}
		
		/**
		 * Exit point.
		 */
		override protected function onExit():void {
			// 
			
			super.onExit();
		}
		
		/**
		 * Destructor.
		 */
		override protected function destroy():void {
			destroyMainMenu();
			destroyLogo();
			
			super.destroy();
		}
		
		/**
		 * Resize view.
		 */
		override protected function resize():void {
			moveLogo();
			moveMainMenu();
		}
	}
}
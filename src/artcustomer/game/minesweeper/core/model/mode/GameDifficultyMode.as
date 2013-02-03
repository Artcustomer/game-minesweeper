package artcustomer.game.minesweeper.core.model.mode {
	import flash.utils.Dictionary;
	
	import artcustomer.maxima.base.IDestroyable;
	import artcustomer.maxima.errors.IllegalGameError;
	
	import artcustomer.game.minesweeper.core.model.mode.type.DifficultyMode;
	
	
	/**
	 * GameDifficultyMode
	 * 
	 * @author David Massenot
	 */
	public class GameDifficultyMode implements IDestroyable {
		private static var __instance:GameDifficultyMode;
		private static var __allowInstantiation:Boolean;
		
		private var _modes:Dictionary;
		
		private var _currentMode:DifficultyMode;
		
		
		/**
		 * Constructor
		 */
		public function GameDifficultyMode() {
			if (!__allowInstantiation) {
				throw new IllegalGameError(IllegalGameError.E_SINGLETON_CLASS);
				
				return;
			}
			
			setupStack();
		}
		
		//---------------------------------------------------------------------
		//  Modes
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStack():void {
			_modes = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function disposeStack():void {
			var id:String;
			var mode:DifficultyMode;
			
			for (id in _modes) {
				mode = _modes[id] as DifficultyMode;
				
				if (mode) {
					mode.destroy();
					mode = null;
				}
				
				_modes[id] = undefined;
				delete _modes[id];
			}
		}
		
		/**
		 * @private
		 */
		private function destroyStack():void {
			_modes = null;
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			disposeStack();
			destroyStack();
			
			_currentMode = null;
			
			__instance = null;
			__allowInstantiation = false;
		}
		
		/**
		 * Add mode.
		 * 
		 * @param	name
		 * @param	type
		 */
		public function addMode(name:String, type:String, rows:int, columns:int, mines:int):void {
			var mode:DifficultyMode = new DifficultyMode();
			
			mode.name = name;
			mode.type = type;
			mode.rows = rows;
			mode.columns = columns;
			mode.mines = mines;
			
			_modes[type] = mode;
		}
		
		/**
		 * Get mode.
		 * 
		 * @param	type
		 * @return
		 */
		public function getMode(type:String):DifficultyMode {
			return _modes[type];
		}
		
		/**
		 * Test mode.
		 * 
		 * @param	type
		 * @return
		 */
		public function hasMode(type:String):Boolean {
			return _modes[type] != undefined;
		}
		
		/**
		 * Set current mode.
		 * 
		 * @param	type
		 * @return
		 */
		public function setMode(type:String):Boolean {
			if (this.hasMode(type)) {
				_currentMode = this.getMode(type);
				
				return true;
			}
			
			return false;
		}
		
		
		/**
		 * Instantiate GameDifficultyMode.
		 */
		public static function getInstance():GameDifficultyMode {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new GameDifficultyMode();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get currentMode():DifficultyMode {
			return _currentMode;
		}
	}
}
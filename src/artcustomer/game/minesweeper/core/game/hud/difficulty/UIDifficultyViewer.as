package artcustomer.game.minesweeper.core.game.hud.difficulty {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.GridFitType;
	import flash.text.AntiAliasType;
	
	import artcustomer.maxima.context.GameContext;
	import artcustomer.maxima.base.IDestroyable;
	
	import artcustomer.game.minesweeper.utils.consts.*;
	
	
	/**
	 * UIDifficultyViewer
	 * 
	 * @author David Massenot
	 */
	public class UIDifficultyViewer extends Sprite implements IDestroyable {
		private var _bitmap:Bitmap;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		
		/**
		 * Constructor
		 */
		public function UIDifficultyViewer() {
			setupBitmap();
			setupTextFormat();
			setupTextField();
			setTextField('Unknown');
		}
		
		//---------------------------------------------------------------------
		//  Bitmap
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupBitmap():void {
			var bmpSource:Bitmap = GameContext.currentContext.instance.assetsLoader.getAssetByName('flag_small').data;
			
			_bitmap = new Bitmap(bmpSource.bitmapData.clone());
			
			this.addChild(_bitmap);
		}
		
		/**
		 * @private
		 */
		private function destroyBitmap():void {
			this.removeChild(_bitmap);
			
			_bitmap = null;
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
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.mouseWheelEnabled = false;
			_textField.defaultTextFormat = _textFormat;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.gridFitType = GridFitType.PIXEL;
			
			_textField.x = 30;
			
			this.addChild(_textField);
		}
		
		/**
		 * @private
		 */
		private function destroyTextField():void {
			this.removeChild(_textField);
			
			_textField = null;
		}
		
		/**
		 * @private
		 */
		private function setTextField(text:String):void {
			if (text) _textField.text = text;
		}
		
		
		/**
		 * Destructor
		 */
		public function destroy():void {
			destroyTextField();
			destroyTextFormat();
			destroyBitmap();
		}
		
		/**
		 * Update difficulty value in text field.
		 * 
		 * @param	value
		 */
		public function updateDifficulty(value:String):void {
			setTextField(value);
		}
	}
}
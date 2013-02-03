package artcustomer.game.minesweeper.display.ui.menu.items {
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.GridFitType;
	import flash.text.AntiAliasType;
	
	import artcustomer.maxima.engine.AssetsLoader;
	import artcustomer.maxima.extensions.display.ui.list.item.AbstractListItem;
	
	import artcustomer.game.minesweeper.core.model.vo.MainMenuValueObject;
	import artcustomer.game.minesweeper.utils.consts.*;
	
	
	/**
	 * MainMenuItem
	 * 
	 * @author David Massenot
	 */
	public class MainMenuItem extends AbstractListItem {
		private var _bitmap:Bitmap;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		
		/**
		 * Constructor
		 */
		public function MainMenuItem() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  Bitmap
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupBitmap():void {
			var bmpSource:Bitmap = AssetsLoader.getInstance().getAssetByName('mine_small').data;
			
			_bitmap = new Bitmap(bmpSource.bitmapData.clone());
			_bitmap.y = 7;
			
			this.addChild(_bitmap);
		}
		
		/**
		 * @private
		 */
		private function destroyBitmap():void {
			this.removeChild(_bitmap);
			
			_bitmap = null;
		}
		
		/**
		 * @private
		 */
		private function toggleBitmapVisibility():void {
			_bitmap.visible = !_bitmap.visible;
		}
		
		//---------------------------------------------------------------------
		//  Text
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTextFormat():void {
			_textFormat = new TextFormat(GameFonts.MAIN_FONT_NAME, 36, 0xA97C50);
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
			
			_textField.x = 40;
			
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
			if (text) _textField.text = text.toUpperCase();
		}
		
		/**
		 * @private
		 */
		private function setTextFieldAlpha(alpha:Number):void {
			_textField.alpha = alpha;
		}
		
		
		/**
		 * Entry point.
		 */
		override public function setup():void {
			var title:String = (this.valueObject as MainMenuValueObject).title;
			
			setupBitmap();
			setupTextFormat();
			setupTextField();
			setTextField(title);
			
			this.unfocus();
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			destroyBitmap();
			destroyTextField();
			destroyTextFormat();
			
			super.destroy();
		}
		
		/**
		 * On focus.
		 */
		override public function focus():void {
			setTextFieldAlpha(1);
			toggleBitmapVisibility();
			
			super.focus();
		}
		
		/**
		 * On unfocus.
		 */
		override public function unfocus():void {
			setTextFieldAlpha(.5);
			toggleBitmapVisibility();
			
			super.unfocus();
		}
		
		/**
		 * On select.
		 */
		override public function select():void {
			// 
			
			super.select();
		}
	}
}
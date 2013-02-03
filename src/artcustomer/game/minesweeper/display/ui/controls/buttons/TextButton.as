package artcustomer.game.minesweeper.display.ui.controls.buttons {
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.GridFitType;
	import flash.text.AntiAliasType;
	
	import artcustomer.maxima.base.IDestroyable;
	
	import artcustomer.game.minesweeper.utils.consts.*;
	
	
	/**
	 * TextButton
	 * 
	 * @author David Massenot
	 */
	public class TextButton extends Sprite implements IDestroyable {
		public static const ON_BUTTON_SELECT:String = 'onButtonSelect';
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _title:String;
		
		
		/**
		 * Constructor
		 */
		public function TextButton(title:String) {
			_title = title;
			
			setupTextFormat();
			setupTextField();
			setTextField();
			bindParams();
		}
		
		//---------------------------------------------------------------------
		//  Params
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function bindParams():void {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, handleMouse, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, handleMouse, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, handleMouse, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unbindParams():void {
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			this.removeEventListener(MouseEvent.MOUSE_OUT, handleMouse);
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
				case('mouseOver'):
					actionOver();
					break;
					
				case('mouseOut'):
					actionOut();
					break;
					
				case('click'):
					actionClick();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Actions
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function actionOver():void {
			this.alpha = .5;
		}
		
		/**
		 * @private
		 */
		private function actionOut():void {
			this.alpha = 1;
		}
		
		/**
		 * @private
		 */
		private function actionClick():void {
			this.dispatchEvent(new Event(TextButton.ON_BUTTON_SELECT));
		}
		
		//---------------------------------------------------------------------
		//  Text
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTextFormat():void {
			_textFormat = new TextFormat(GameFonts.MAIN_FONT_NAME, 24, 0xC2B59B);
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
		private function setTextField():void {
			_textField.text = _title;
		}
		
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			unbindParams();
			destroyTextField();
			destroyTextFormat();
			
			_title = null;
		}
		
		/**
		 * Set button title.
		 * 
		 * @param	title
		 */
		public function setTitle(title:String):void {
			_title = title;
			
			setTextField();
		}
		
		
		/**
		 * @private
		 */
		public function get title():String {
			return _title;
		}
	}
}
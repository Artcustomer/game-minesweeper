package artcustomer.game.minesweeper.display.ui.menu {
	import flash.events.MouseEvent;
	
	import artcustomer.maxima.engine.Shore;
	import artcustomer.maxima.extensions.display.ui.list.AbstractList;
	import artcustomer.maxima.extensions.display.ui.list.item.AbstractListItem;
	import artcustomer.maxima.extensions.display.ui.list.layout.VerticalListLayout;
	
	import artcustomer.game.minesweeper.core.model.vo.MainMenuValueObject;
	import artcustomer.game.minesweeper.display.ui.menu.items.MainMenuItem;
	import artcustomer.game.minesweeper.utils.consts.ShoreProperties;
	
	
	/**
	 * MainMenu
	 * 
	 * @author David Massenot
	 */
	public class MainMenu extends AbstractList {
		private var _xmlData:XMLList;
		
		private var _layout:VerticalListLayout;
		
		
		/**
		 * Constructor
		 */
		public function MainMenu(xmlData:XMLList) {
			_xmlData = xmlData;
			
			super();
			
			parseXMLData();
			setDisplayLayout();
			bindParams();
			
			this.focusAt(0);
		}
		
		//---------------------------------------------------------------------
		//  Binding
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function bindParams():void {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, handleMouse, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, handleMouse, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unbindParams():void {
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			this.removeEventListener(MouseEvent.CLICK, handleMouse);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleMouse(e:MouseEvent):void {
			var item:AbstractListItem = e.target as AbstractListItem;
			
			switch (e.type) {
				case('mouseOver'):
					this.focusAt(item.valueObject.index);
					break;
					
				case('click'):
					this.select();
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Layout
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setDisplayLayout():void {
			_layout = new VerticalListLayout();
			_layout.margin = 10;
			
			this.setLayout(_layout);
		}
		
		//---------------------------------------------------------------------
		//  Data
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function parseXMLData():void {
			var i:int = 0;
			var length:int = _xmlData.length();
			var xmlNode:XML;
			var valueObject:MainMenuValueObject;
			var xmlChildNode:*;
			
			for (i ; i < length ; i++) {
				xmlNode = _xmlData[i];
				
				valueObject = new MainMenuValueObject();
				valueObject.type = xmlNode.@type;
				valueObject.title = xmlNode.title[Shore.getInstance().get(ShoreProperties.LANGUAGE)];
				valueObject.difficulty = xmlNode.difficulty;
				
				this.addItemAt(MainMenuItem, valueObject);
			}
		}
		
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			unbindParams();
			
			_xmlData = null;
			_layout = null;
			
			super.destroy();
		}
	}
}
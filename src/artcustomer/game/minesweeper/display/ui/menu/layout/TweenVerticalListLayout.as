/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.game.minesweeper.display.ui.menu.layout {
	import artcustomer.maxima.extensions.display.ui.list.layout.*;
	
	import artcustomer.game.minesweeper.display.ui.menu.items.MainMenuItem;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	
	/**
	 * TweenVerticalListLayout
	 * 
	 * @author David Massenot
	 */
	public class TweenVerticalListLayout extends AbstractListLayout implements IListLayout {
		private var _margin:int;
		
		private var _completeCallback:Function;
		
		
		/**
		 * Constructor
		 */
		public function TweenVerticalListLayout() {
			super();
		}
		
		//---------------------------------------------------------------------
		//  Tween
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onCompleteTween(current:int, length:int):void {
			if (current >= length - 1) _completeCallback.call();
		}
		
		
		/**
		 * Display items in Layout.
		 */
		public function display():void {
			if (!_displayItems) return;
			
			var i:int = 0;
			var length:int = _displayItems.length;
			var item:MainMenuItem;
			var lastItem:MainMenuItem;
			
			for (i ; i < length ; i++) {
				item = _displayItems[i] as MainMenuItem;
				item.x = 0;
				item.y = 0;
				
				if (i != 0) {
					lastItem = _displayItems[i - 1] as MainMenuItem;
					
					item.y = lastItem.y + lastItem.height + _margin;
				}
				
				if (!item.added) {
					item.added = true;
					item.alpha = 0;
					item.x = -150;
					
					TweenLite.to(item, 1, { alpha : 1, x : 0, ease:Strong.easeOut, delay : i * .1 } );
				}
			}
		}
		
		/**
		 * Hide items in Layout.
		 */
		public function hide(complete:Function):void {
			_completeCallback = complete;
			
			var i:int = 0;
			var length:int = _displayItems.length;
			var item:MainMenuItem;
			
			for (i ; i < length ; i++) {
				item = _displayItems[i] as MainMenuItem;
				
				TweenLite.to(item, .5, { alpha : 0, x : -150, ease:Strong.easeOut, delay : i * .05, onComplete : onCompleteTween, onCompleteParams : [i, length] } );
			}
		}
		
		/**
		 * Destructor.
		 */
		override public function destroy():void {
			_margin = 0;
			_completeCallback = null;
			
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
		public function set margin(value:int):void {
			_margin = value;
		}
		
		/**
		 * @private
		 */
		public function get margin():int {
			return _margin;
		}
	}
}
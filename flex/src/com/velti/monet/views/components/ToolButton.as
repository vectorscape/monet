package com.velti.monet.views.components
{
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	/**
	 * Button which doesn't allow itself to be de-selected
	 * by the user directly clicking on it.
	 *  
	 * @author Ian Serlin
	 */	
	public class ToolButton extends Button {
		/**
		 * The cursor to change to when this tool is active. 
		 */
		public var cursor:Class;
		
		/**
		 * True if you want to prevent non-programmatic
		 * deselection. 
		 * 
		 * @default true
		 */
		public var preventDeselection:Boolean = true;
		
		/**
		 * @inheritDoc 
		 */		
		override protected function clickHandler(event:MouseEvent):void {
			if( !this.selected || !preventDeselection ){
				super.clickHandler( event );
			}
		}
		
	}
}
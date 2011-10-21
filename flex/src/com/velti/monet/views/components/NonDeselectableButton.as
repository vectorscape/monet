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
	public class NonDeselectableButton extends Button {
		
		/**
		 * @inheritDoc 
		 */		
		override protected function clickHandler(event:MouseEvent):void {
			if( !this.selected ){
				super.clickHandler( event );
			}
		}
		
	}
}
package com.velti.monet.events {
	import com.velti.monet.models.Element;
	
	/**
	 * Event class dispatched when an interaction with an ElementRenderer occurs.
	 * 
	 * @author Ian Serlin
	 */	
	public class ElementRendererEvent extends BaseEvent {
		
		/**
		 * Dispatched when an the user double clicks on an element renderer.
		 */		
		public static const DOUBLE_CLICK:String = "elementRendererDoubleClick";
		
		/**
		 * Event type dispatched when the user mouses down on an element renderer. 
		 */		
		public static const MOUSE_DOWN:String = "elementRendererMouseDown";
		
		private var _element:Element;
		
		/**
		 * The element to act on. 
		 */		
		public function get element():Element { return _element}
		
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param element
		 * @param bubbles
		 * @param cancelable
		 */		
		public function ElementRendererEvent(type:String, element:Element=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			this._element = element;
			super(type, bubbles, cancelable);
		}
	}
}
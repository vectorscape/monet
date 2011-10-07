package com.velti.monet.events {
	import com.velti.monet.models.Element;
	
	/**
	 * Event class dispatched when an interaction with an ElementRenderer occurs.
	 * 
	 * @author Ian Serlin
	 */	
	public class ElementRendererEvent extends BaseEvent {
		
		/**
		 * Event type dispatched when the user wants to view the details for a particular element. 
		 */		
		public static const SHOW_DETAILS:String = "showDetails";
		
		/**
		 * Event type dispatched when the user wants to select a particular renderer. 
		 */		
		public static const SELECT:String = "select";
		
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
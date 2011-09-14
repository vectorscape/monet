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
		
		/**
		 * The element associated with this event, if any. 
		 */		
		public var element:Element;
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param element
		 * @param bubbles
		 * @param cancelable
		 */		
		public function ElementRendererEvent(type:String, element:Element=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			this.element = element;
			super(type, bubbles, cancelable);
		}
	}
}
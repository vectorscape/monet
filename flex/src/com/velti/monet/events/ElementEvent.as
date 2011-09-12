package com.velti.monet.events {
	import flash.events.Event;
	
	/**
	 * Event class related to events locally dispatched by
	 * <code>com.velti.models.Element</code>s. 
	 * 
	 * @author Ian Serlin
	 */	
	public class ElementEvent extends Event {
		
		/**
		 * Event type to dispatch when an Element's set of descendents have changed somehow. 
		 */		
		public static const DESCENDENTS_CHANGED:String = "descendentsChanged";
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function ElementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
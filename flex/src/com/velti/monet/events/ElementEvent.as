package com.velti.monet.events {
	import com.velti.monet.models.Element;
	
	
	/**
	 * Event class related to events locally dispatched by
	 * <code>com.velti.models.Element</code>s. 
	 * 
	 * @author Ian Serlin
	 */	
	public class ElementEvent extends BaseEvent {
		
		/**
		 * Event type to dispatch when an Element's set of descendents have changed somehow. 
		 */		
		public static const DESCENDENTS_CHANGED:String = "descendentsChanged";
		
		/**
		 * Event type to dispatch when an Element's set of descendents have changed somehow. 
		 */		
		public static const PARENTS_CHANGED:String = "parentsChanged";
		
		/**
		 * The element to act on. 
		 */		
		public var element:Element;
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function ElementEvent(type:String, element:Element = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.element = element;
		}
	}
}
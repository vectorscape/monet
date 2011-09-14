package com.velti.monet.events {
	import com.velti.monet.models.Element;
	
	/**
	 * Events related to the manipulation
	 * of a <code>com.velti.monet.models.Plan</code>.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanEvent extends BaseEvent {
		
		/**
		 * Event type that is dispatched when the user wants to
		 * begin working on a fresh plan. 
		 */		
		public static const NEW_PLAN:String = "new";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * add an element to the current plan. The <code>element</code>
		 * property of this event *must* contain the element to be added. 
		 */		
		public static const ADD_ELEMENT:String = "addElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * remove an element from the current plan. The <code>element</code>
		 * property of this event *must* contain the element to be removed. 
		 */		
		public static const REMOVE_ELEMENT:String = "removeElement";
		
		/**
		 * The <code>com.velti.monet.models.Element</code>
		 * instance associated with this event, if any. 
		 */		
		public var element:Element;
		
		/**
		 * The <code>com.velti.monet.models.Element</code>
		 * instance that is the actionable target of this event,
		 * e.g. for a drag and drop behavior, if any. 
		 */		
		public var targetElement:Element;
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param element
		 * @param bubbles
		 * @param cancelable
		 */		
		public function PlanEvent(type:String, element:Element=null, targetElement:Element=null, bubbles:Boolean=true, cancelable:Boolean=false) {
			this.element = element;
			this.targetElement = targetElement;
			super(type, bubbles, cancelable);
		}
	}
}
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
		 * Event type to dispatch when the system requests the an element's details view be shown.
		 */		
		public static const SHOW_DETAILS:String = "elementShowDetails";
		
		/**
		 * Event type to dispatch when an the system requests that a set of elements be selected.
		 * 
		 * NOTE: This event uses the *elements* property and not the *element* property to allow batch selection. 
		 */		
		public static const SELECT:String = "elementSelect";
		
		/**
		 * Event type to dispatch when an the system requests that an element be added to the current selection. 
		 */		
		public static const ADD_TO_SELECTION:String = "elementAddToSelection";
		
		/**
		 * Event type to dispatch when an the system requests that an element be removed from the current selection. 
		 */		
		public static const REMOVE_FROM_SELECTION:String = "elementRemoveFromSelection";
		
		/**
		 * Event type to dispatch when an the system requests that an element be selected. 
		 */		
		public static const DESELECT:String = "elementDeselect";
		
		
		/**
		 * Event type to dispatch when an Element's set of descendents have changed somehow. 
		 */		
		public static const DESCENDENTS_CHANGED:String = "descendentsChanged";
		
		/**
		 * Event type to dispatch when an Element's set of descendents have changed somehow. 
		 */		
		public static const PARENTS_CHANGED:String = "parentsChanged";
		
		/**
		 * Event type to dispatch when the Element's element data changes 
		 */		
		public static const DATA_CHANGE:String = "dataChange";
		
		public static const HOVERED:String = "elementHovered";
		
		public static const UNHOVERED:String = "elementUnHovered";
		
		/**
		 * @private 
		 */		
		private var _element:Element;
		
		/**
		 * The element to act on. 
		 */		
		public function get element():Element {
			return _element;
		}
		
		/**
		 * @private 
		 */		
		private var _elements:Array;
		
		/**
		 * The elements to act on. 
		 */		
		public function get elements():Array {
			return _elements;
		}
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function ElementEvent(type:String, element:Element = null, elements:Array=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this._element = element;
			this._elements = elements;
		}
	}
}
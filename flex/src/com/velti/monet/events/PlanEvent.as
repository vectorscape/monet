
package com.velti.monet.events {
	import com.velti.monet.models.AdvertisementType;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.SubType;
	
	/**
	 * Events related to the manipulation
	 * of a <code>com.velti.monet.models.Plan</code>.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanEvent extends BaseEvent {
		
		/**
		 * @private 
		 */		
		private var _element:Element;
		/**
		 * @private 
		 */		
		private var _targetElement:Element;
		/**
		 * @private 
		 */		
		private var _subType:SubType;
		/**
		 * @private
		 */
		private var _showDetails:Boolean;
		
		/**
		 * Event type that is dispatched when the user wants to
		 * submit the plan. 
		 */		
		public static const SUBMIT_PLAN:String = "submitPlan";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * begin working on a fresh plan. 
		 */		
		public static const NEW_PLAN:String = "new";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * add an element to the current plan. The <code>element</code>
		 * property of this event *must* contain the element to be added.
		 * 
		 * The <code>targetElement</code> property may be specified
		 * if the user has chosen a particular element to add the new element to.
		 */		
		public static const ADD_ELEMENT:String = "addElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * move an existing element from one existing element to another.
		 * The <code>element</code> property of this event *must* contain 
		 * the element to be moved and the <code>targetElement</code>
		 * property *must* contain the existing element that the user
		 * wants the element to become the new parent of. 
		 */        
		public static const MOVE_ELEMENT:String = "moveElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * copy an existing element branch from one existing element to another.
		 * The <code>element</code> property of this event *must* contain 
		 * the element to be copied and the <code>targetElement</code>
		 * property *must* contain the existing element that the user
		 * wants the new duplicate element to become the new parent of. 
		 */        
		public static const COPY_ELEMENT:String = "copyElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * remove an element from the current plan. The <code>element</code>
		 * property of this event *must* contain the element to be removed. 
		 */		
		public static const REMOVE_ELEMENT:String = "removeElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * replace an existing element in the current plan.
		 * 
		 * The <code>targetElement</code> property of this event *must* contain 
		 * the element we want to replace. 
		 * 
		 * The <code>element</code> property of this event *must* contain 
		 * the element we want to replace the target element with. 
		 */		
		public static const REPLACE_ELEMENT:String = "replaceElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * remove an element and its sub-branch from the current plan. 
		 * The <code>element</code> property of this event *must* 
		 * contain the element whose branch is to be removed. 
		 */		
		public static const REMOVE_BRANCH:String = "removeBranch";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * assign a new advertisementType to an existing ad element. 
		 * The <code>element</code> property of this event *must* 
		 * contain the element to which the new advertisement
		 * element will be added.
		 * 
		 * The <code>targetElement</code> property should not be used for this event.
		 * 
		 * The <code>subType</code> property *must* be specified
		 * and so the new interaction can be properly added.
		 */			
		public static const ASSIGN_ADVERTISEMENT:String = "elementAssignAdType";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * assign a Create Library Item to an existing ad element. 
		 * The <code>element</code> property of this event *must* 
		 * contain the element to which the new advertisement
		 * element will be added.
		 * 
		 * The <code>targetElement</code> property should not be used for this event.
		 * 
		 * The <code>subType</code> property *must* be specified with the CreativeLibraryItem
		 * and so the create library item can be properly added.
		 */			
		public static const ASSIGN_CREATIVE_LIBRARY_ITEM:String = "elementAssignCreativeLibraryItem";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * assign a new interactionType to an existing interaciton element. 
		 * The <code>element</code> property of this event *must* 
		 * contain the element to which the interaction
		 * element will be added.
		 * 
		 * The <code>targetElement</code> property should not be used for this event.
		 * 
		 * The <code>subType</code> property *must* be specified
		 * and so the new interaction can be properly added.
		 */			
		public static const ASSIGN_INTERACTION:String = "elementAssignInteractionType";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * "pivot" on a particular element in the plan.
		 * 
		 * The <code>element</code> property *must* contain the element
		 * the user wishes to pivot on.
		 */			
		public static const PIVOT:String = "pivotOnElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * exit "pivot" mode.
		 */			
		public static const UNPIVOT:String = "unPivotOnElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * "trace a path" on a particular element in the plan.
		 * 
		 * The <code>element</code> property *must* contain the element
		 * the user wishes to pivot on.
		 */			
		public static const TRACE:String = "traceOnElement";
		
		/**
		 * Event type that is dispatched when the user wants to
		 * exit "trace a path" mode.
		 */			
		public static const UNTRACE:String = "unTraceOnElement";
		
		/**
		 * The <code>com.velti.monet.models.Element</code>
		 * instance associated with this event, if any. 
		 */		
		public function get element():Element {return _element}
		
		/**
		 * The <code>com.velti.monet.models.Element</code>
		 * instance that is the actionable target of this event,
		 * e.g. for a drag and drop behavior, if any. 
		 */		
		public function get targetElement():Element { return _targetElement}
		
		/**
		 * The <code>com.velti.monet.models.AdvertisementType</code>
		 * instance specifying the type of interaction the user wants
		 * to add during an <code>ADD_ADVERTISEMENT</code>, <code>ASSIGN_ADVERTISEMENT</code>,
		 * <code>ADD_INTERACTION</code> or <code>ASSIGN_INTERACTION</code> event. 
		 */		
		public function get subType():SubType { return _subType; }
		/**
		 * Whether or not to show the details for this element
		 * 
		 */		
		public function get shouldShowDetails():Boolean { return _showDetails;}
		
		
		/**
		 * Constructor
		 * @param type
		 * @param element
		 * @param targetElement
		 * @param subType
		 * @param showDetails
		 * @param bubbles
		 * @param cancelable
		 * 
		 */			
		public function PlanEvent(type:String, element:Element=null, 
				targetElement:Element=null, subType:SubType=null, 
				showDetails:Boolean = true, bubbles:Boolean=true, 
				cancelable:Boolean=false) {
			this._element = element;
			this._targetElement = targetElement;
			this._subType = subType;
			this._showDetails = showDetails;
			super(type, bubbles, cancelable);
		}
	}
}
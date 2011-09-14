package com.velti.monet.controllers {
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Advertisement;
	import com.velti.monet.models.Audience;
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Interaction;
	import com.velti.monet.models.Placement;
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.Publisher;
	
	/**
	 * Manages the concerns of the represented plan as a whole.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanController {
		
		/**
		 * Handle to the current plan the user is working on. 
		 */		
		[Inject]
		public var plan:Plan;
		
		/**
		 * Constructor 
		 */		
		public function PlanController() {
		}
		
		/**
		 * Handles a request to start working on a brand new plan. 
		 */		
		[EventHandler("PlanEvent.NEW_PLAN")]
		public function plan_new( e:PlanEvent ):void {
			newPlan();
		}
		
		/**
		 * Handles a request to add an element the plan. 
		 */		
		[EventHandler("PlanEvent.ADD_ELEMENT")]
		public function plan_addElement( e:PlanEvent ):void {
			addElement( e.element, e.targetElement );
		}

		/**
		 * Handles a request to remove an element from the plan. 
		 */		
		[EventHandler("PlanEvent.REMOVE_ELEMENT")]
		public function plan_removeElement( e:PlanEvent ):void {
			removeElement( e.element );
		}
		
		/**
		 * Resets the plan to the blank slate state. 
		 */		
		internal function newPlan():void {
			plan.removeAll();
			createPlanDefaults();
		}
		
		/**
		 * Removes an element from the current plan being worked on.
		 * 
		 * @param element The element to remove from the current plan
		 */
		internal function removeElement( element:Element ):void {
			if( plan ){
				plan.removeItemByIndex( element.elementID );
			}
		}
		
		/**
		 * Adds an element to the current plan being worked on.
		 * 
		 * @param element The element to add to the current plan
		 * @param targetElement (optional) The element to add the first element to as a descendent
		 */
		internal function addElement( element:Element, targetElement:Element=null ):void {
			if( plan ){
				var targetParentType:Class;
			// 1. determine the type of parent element
			// we need to add the new element to
				if(element is Audience)
					targetParentType = Campaign
				if(element is Publisher)
					targetParentType = Audience;
				if(element is Placement)
					targetParentType = Publisher;
				if(element is Advertisement)
					targetParentType = Placement
				if(element is Interaction)
					targetParentType = Advertisement;
				else
					trace("element type not handled " + typeof(element));
				
				// 2. find an existing element of the target type to add the new element to
				if( targetParentType ){
					if( targetElement && targetElement is targetParentType ){
						// 2a. attempt to add the element at the position requested, if there was one
						targetElement.descendents.addItem( element.elementID );
					}else{
						// 2b. simply add the element to the first appropriate element in the plan
						// if no position was specifically requested.
						for each( var existingElement:Element in plan ){
							if( existingElement is targetParentType ){
								existingElement.descendents.addItem( element.elementID );
								break;
							}
						}
					}
				}
				// 3. simply add the element to the plan's collection 
				plan.addItem( element );
			}
		}
		
		/**
		 * Creates the default set of elements
		 * and adds them to this plan. 
		 */		
		internal function createPlanDefaults():void {
			var parentElement:Element = new Campaign();
			var childElement:Element = new Audience();

			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Publisher();
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Placement();
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Advertisement();
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Interaction();
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			plan.addItem( childElement );
		}
	}
}
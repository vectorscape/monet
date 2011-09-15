package com.velti.monet.controllers {
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	
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
		 * Handles a request to move an existing element from 
		 * one parent to another. 
		 */        
		[EventHandler("PlanEvent.MOVE_ELEMENT")]
		public function plan_moveElement( e:PlanEvent ):void {
			moveElement( e.element, e.targetElement );
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
		 * Moves an existing element from one parent element to another, if possible.
		 * 
		 * @param element The element you want to move.
		 * @param targetElement The element you want the first element moved to.
		 */        
		internal function moveElement( element:Element, targetElement:Element ):void {
			if( plan ){
				var existingParentElement:Element;
				for each( existingParentElement in plan ){
					if( existingParentElement.descendents.contains( element.elementID ) ){
						break;
					}
				}
				if( existingParentElement ){
					addElement( element, targetElement );
					existingParentElement.descendents.removeItemAt( existingParentElement.descendents.getItemIndex( element.elementID ) );
				}else{
					throw new Error("Cannot move an element that is not already part of the campaign, try adding instead.");
				}
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
				// 1. determine the type of parent element
				// we need to add the new element to
				var targetParentType:ElementType;
				switch( element.type ){
					case ElementType.AUDIENCE:
						targetParentType = ElementType.CAMPAIGN;
						break;
					case ElementType.PUBLISHER:
						targetParentType = ElementType.AUDIENCE;
						break;
					case ElementType.PLACEMENT:
						targetParentType = ElementType.PUBLISHER;
						break;
					case ElementType.AD:
						targetParentType = ElementType.PLACEMENT;
						break;
					case ElementType.INTERACTION:
						targetParentType = ElementType.AD;
						break;
					default :
						trace("element type not handled " + element.type);
						break;
				}
				// 2. find an existing element of the target type to add the new element to
				if( targetParentType ){
					if( targetElement && targetElement.type == targetParentType ){
						// 2a. attempt to add the element at the position requested, if there was one
						targetElement.descendents.addItem( element.elementID );
					}else{
						// 2b. simply add the element to the first appropriate element in the plan
						// if no position was specifically requested.
						for each( var existingElement:Element in plan ){
							if( existingElement.type == targetParentType ){
								existingElement.descendents.addItem( element.elementID );
								break;
							}
						}
					}
				}
				// 3. simply add the element to the plan's collection 
				plan.addItem( element );
				
				// 4. generate this element's children down to the Interaction level
				if( element.descendents.length == 0 ){
					var childElement:Element;
					while( element.type.descendentType && element.type.descendentType != element.type ){
						childElement = new Element( element.type.descendentType );
						element.descendents.addItem( childElement.elementID );
						plan.addItem( childElement );
						element = childElement;
					}
				}
			}
		}
		
		/**
		 * Creates the default set of elements
		 * and adds them to this plan. 
		 */		
		internal function createPlanDefaults():void {
			var parentElement:Element = new Element( ElementType.CAMPAIGN );
			var childElement:Element = new Element( ElementType.AUDIENCE );
			
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.PUBLISHER );
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.PLACEMENT );
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.AD );
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.INTERACTION );
			parentElement.descendents.addItem( childElement.elementID );
			plan.addItem( parentElement );
			
			plan.addItem( childElement );
		}
	}
}
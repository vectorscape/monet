package com.velti.monet.controllers {
	import com.velti.monet.events.ElementRendererEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.InteractionType;
	import com.velti.monet.models.Plan;
	import com.velti.monet.utils.ElementUtils;
	
	import flash.events.IEventDispatcher;
	
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
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
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher
		
		/**
		 * Constructor 
		 */		
		public function PlanController() {
		}
		/**
		 * Invoked after all the injects have taken place for this bean by swiz
		 */		
		[PostConstruct]
		public function postInjection():void {
			plan.addEventListener(CollectionEvent.COLLECTION_CHANGE, plan_collectionChange, false,0,true);
		}
		
		/**
		 * Handler for when the plan collection changes
		 * @param event
		 * 
		 */		
		internal function plan_collectionChange(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.ADD) {
				for each(var element:Element in event.items) {
					if (element.type == ElementType.CAMPAIGN) {
						dispatcher.dispatchEvent(new ElementRendererEvent(ElementRendererEvent.SHOW_DETAILS, element));
					}
				}
			}
		}
		/**
		 * Invoked before the bean is torn down by swiz 
		 */		
		[PreDestroy]
		public function preDestroy():void {
			plan.removeEventListener(CollectionEvent.COLLECTION_CHANGE, plan_collectionChange);
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
			dispatcher.dispatchEvent(new ElementRendererEvent(ElementRendererEvent.SHOW_DETAILS, e.element));
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
		 * Handles a request to add an element the plan. 
		 */		
		[EventHandler("PlanEvent.ADD_INTERACTION")]
		public function plan_addInteraction( e:PlanEvent ):void {
			addInteraction( e.element, e.interactionType );
		}
		
		/**
		 * Resets the plan to the blank slate state. 
		 */		
		internal function newPlan():void {
			plan.removeAll();
			createPlanDefaults();
		}
		
		/**
		 * Adds a new Interaction element to the target element and pre-specifies
		 * the interaction's interaction type.
		 * 
		 * @param targetElement the element you want to add a child interaction node to
		 * @param interactionType the type of interaction you want to add
		 */		
		internal function addInteraction( targetElement:Element, interactionType:InteractionType ):void {
			var newElement:Element = new Element( ElementType.INTERACTION, interactionType.label );
			addElement( newElement, targetElement );
		}
		
		/**
		 * Removes an element from the current plan being worked on.
		 * 
		 * @param element The element to remove from the current plan
		 */
		internal function removeElement( element:Element ):void {
			if( plan ){
				plan.removeItemByIndex( element.elementID );
				var parents:Array = plan.getParentElementsOfElement( element );
				var descdendents:Array = plan.getDescendentElementsOfElement( element );
				var associatedElement:Element;
				for each( associatedElement in parents ){
					ElementUtils.unlinkElements( associatedElement, element );
				}
				for each( associatedElement in descdendents ){
					ElementUtils.unlinkElements( element, associatedElement );
				}
					
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
				var existingParentElements:Array = [];
				var existingParentElement:Element;
				
				for each( existingParentElement in plan ){
					if( existingParentElement.descendents.contains( element.elementID ) ){
						existingParentElements.push( existingParentElement );
					}
				}
				if( existingParentElements.length > 0 ){
					addElement( element, targetElement );
					for each( existingParentElement in existingParentElements ){
						ElementUtils.unlinkElements( existingParentElement, element );
						generateDefaultDescendentElementsForElement( existingParentElement );
					}
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
				// 1. determine the type of parent element we need to add the new element to
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
					case ElementType.ADVERTISEMENT:
						targetParentType = ElementType.PLACEMENT;
						break;
					case ElementType.INTERACTION:
						targetParentType = ElementType.ADVERTISEMENT;
						break;
					default :
						trace("element type not handled " + element.type);
						break;
				}
				
				// 2. find an existing element of the target type to add the new element to
				if( targetParentType ){
					if( targetElement && targetElement.type == targetParentType ){
						// 2a. attempt to link the element at the position requested, if there was one
						// and it is already an acceptable position for this element.
						ElementUtils.linkElements( targetElement, element );
					}else if( targetElement ){
						// 2b. attempt to find a proper place in the branch that the element
						// was requested to be added to when the targetElement itself is not an appropriate parent
						var potentialParents:Array = [];
						var potentialParent:Element;
						
						var relativePosition:int = ElementUtils.sortElementsByType( targetElement, element );
						var linked:Boolean = false;
						if( relativePosition == -1 ){
							// 2bi. search down the branch
							potentialParents = plan.getDescendentElementsOfElement( targetElement );
							while( potentialParents.length > 0 ){
								potentialParent = potentialParents[0] as Element
								if( potentialParent.type == targetParentType ){
									ElementUtils.linkElements( potentialParent, element );
									linked = true;
									break;
								}else{
									potentialParents = potentialParents.concat( plan.getDescendentElementsOfElement( potentialParent ) );
									potentialParents.shift();
								}
							}
						}else if( relativePosition == 1 ){
							// 2bii. search up the branch
							potentialParents = plan.getParentElementsOfElement( targetElement );
							while( potentialParents.length > 0 ){
								potentialParent = potentialParents[0] as Element;
								if( potentialParent.type == targetParentType ){
									ElementUtils.linkElements( potentialParent, element );
									linked = true;
									break;
								}else{
									potentialParents = potentialParents.concat( plan.getParentElementsOfElement( potentialParent ) );
									potentialParents.shift();
								}
							}							
						}else if( relativePosition == 0 ){
							// 2biii. elements are at the same level, so add the new element to the targetElement's first parent
							if( targetElement.parents.length > 0 ){
								targetElement = plan.getItemByIndex( targetElement.parents.getItemAt( 0 ) ) as Element;
								ElementUtils.linkElements( targetElement, element );
								linked = true;
							}
						}
						
						if( !linked ){
							// 2biiii. simply link the element to the first appropriate element in the plan
							// because a better target could not be found based on the given target
							linkElementToFirstAppropriateElementInPlan( element, targetParentType );							
						}
					}else{
						// 2c. simply link the element to the first appropriate element in the plan
						// if no position was specifically requested.
						linkElementToFirstAppropriateElementInPlan( element, targetParentType );
					}
				}
				
				// 3. and also add the element to the plan's collection of elements
				plan.addItem( element );
				
				// 4. generate this element's children down to the ElementType.Interaction level
				generateDefaultDescendentElementsForElement( element );
			}
		}
		
		/**
		 * If the given element currently has no descendents, this will create and add
		 * the appropriate blank descendent elements for the particular element type;
		 * 
		 * @param element The element you want to generate the default descendents for
		 */		
		protected function generateDefaultDescendentElementsForElement( element:Element ):void {
			if( element.descendents.length == 0 ){
				var childElement:Element;
				while( element.type.descendentType && element.type.descendentType != element.type ){
					childElement = new Element( element.type.descendentType );
					ElementUtils.linkElements( element, childElement );
					plan.addItem( childElement );
					element = childElement;
				}
			}
		}
		
		/**
		 * Searches through the plan and adds the given element to the first location it finds
		 * that is available.
		 * 
		 * @param element The element you want to add to the plan.
		 * @param targetParentType The type of the element you want to add the given element to
		 */		
		protected function linkElementToFirstAppropriateElementInPlan( element:Element, targetParentType:ElementType ):void {
			for each( var existingElement:Element in plan ){
				if( existingElement.type == targetParentType ){
					ElementUtils.linkElements( existingElement, element );
					break;
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
			
			ElementUtils.linkElements( parentElement, childElement );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.PUBLISHER );
			ElementUtils.linkElements( parentElement, childElement );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.PLACEMENT );
			ElementUtils.linkElements( parentElement, childElement );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.ADVERTISEMENT );
			ElementUtils.linkElements( parentElement, childElement );
			plan.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.INTERACTION );
			ElementUtils.linkElements( parentElement, childElement );
			plan.addItem( parentElement );
			
			plan.addItem( childElement );
		}
	}
}
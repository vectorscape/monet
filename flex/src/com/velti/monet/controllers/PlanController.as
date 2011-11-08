package com.velti.monet.controllers {
	import com.velti.monet.collections.ElementCollection;
	import com.velti.monet.collections.IElementCollection;
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.AdvertisementType;
	import com.velti.monet.models.CreativeLibraryItem;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.InteractionType;
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.models.elementData.AdvertisementElementData;
	import com.velti.monet.models.elementData.InteractionElementData;
	import com.velti.monet.utils.ElementUtils;
	import com.velti.monet.utils.PivotUtils;
	
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * Manages the concerns of the represented plan as a whole.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanController {
		/**
		 * A ref to the presentation model bean 
		 */		
		[Inject]
		public var presentationModel:PresentationModel;
		
		/**
		 * Handle to the current plan the user is working on. 
		 */		
		[Inject]
		public var plan:Plan;
		/**
		 * A ref to the swiz dispatcher 
		 */		
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
			presentationModel.selectedElements.addEventListener(CollectionEvent.COLLECTION_CHANGE, selectedElements_change, false, 0, true);
		}

		/**
		 * Handler for when the plan collection changes
		 * @param event
		 * 
		 */		
		internal function plan_collectionChange(event:CollectionEvent):void {
			var found:Boolean = false;
			var element:Element;
			if(event.kind == CollectionEventKind.ADD) {
				for each(element in event.items) {
					if (element.type == ElementType.CAMPAIGN) {
						found = true;
						break;
					}
				}
			}
			if(found) dispatcher.dispatchEvent(new ElementEvent(ElementEvent.SHOW_DETAILS, element));
		}
		
		/**
		 * Handler for when the plan collection changes
		 * @param event
		 * 
		 */		
		internal function selectedElements_change(event:CollectionEvent):void {
			if( presentationModel.tracePath ){
				tracePath();
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
		 * Handler for when the user wants to submit a plan
		 */		
		[EventHandler("PlanEvent.SUBMIT_PLAN")]
		public function submit_plan(e:PlanEvent):void {
			if(plan.isElementTypesComplete(ElementType.ALL)) {
				presentationModel.planSubmitted = true;
				Alert.show("Plan Submitted","Success"); // NO PMD
			} else
				Alert.show("Please complete all the plan elements first.","Problem"); // NO PMD
		}
		
		/**
		 * Handles a request to add an element the plan. 
		 */		
		[EventHandler("PlanEvent.ADD_ELEMENT")]
		public function plan_addElement( e:PlanEvent ):void {
			addElement( e.element, e.targetElement );
			if(e.shouldShowDetails){
				dispatcher.dispatchEvent(new ElementEvent(ElementEvent.SHOW_DETAILS, e.element));
			}
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
		 * Handles a request to remove an element from the plan. 
		 */		
		[EventHandler("PlanEvent.REMOVE_BRANCH")]
		public function plan_removeBranch( e:PlanEvent ):void {
			removeBranch( e.element );
		}
		
		/**
		 * Handles assigning ads to existing nodes 
		 */		
		[EventHandler("PlanEvent.ASSIGN_ADVERTISEMENT")]
		public function adElement_assignAdvertisementType(e:PlanEvent):void {
			var adData:AdvertisementElementData = e.element.data as AdvertisementElementData;
			adData.type = e.subType as AdvertisementType;
			adData.name = e.subType.label;
			if(e.shouldShowDetails){
				dispatcher.dispatchEvent(new ElementEvent(ElementEvent.SHOW_DETAILS, e.element));
			}
		}
		
		/**
		 * Handles assigning ads to existing nodes 
		 */		
		[EventHandler("PlanEvent.ASSIGN_CREATIVE_LIBRARY_ITEM",properties="element, subType")]
		public function adElement_assignCreativeLibraryItem( element:Element, creativeLibraryItem:CreativeLibraryItem ):void {
			var adData:AdvertisementElementData = element.data as AdvertisementElementData;
			adData.creativeLibraryItem = creativeLibraryItem;
			dispatcher.dispatchEvent(new ElementEvent(ElementEvent.SHOW_DETAILS, element));
		}
		
		/**
		 * Handles assigning ads to existing nodes 
		 */		
		[EventHandler("PlanEvent.ASSIGN_INTERACTION")]
		public function plan_assignAdvertisementType(e:PlanEvent):void {
			var interactionData:InteractionElementData = e.element.data as InteractionElementData;
			interactionData.type = e.subType as InteractionType;
			if(e.shouldShowDetails){
				dispatcher.dispatchEvent(new ElementEvent(ElementEvent.SHOW_DETAILS, e.element));
			}
		}
		
		/**
		 * Handles a request to replace an existing plan element with 
		 * another element. 
		 */		
		[EventHandler("PlanEvent.REPLACE_ELEMENT", properties="element, targetElement")]
		public function plan_replaceElement( element:Element, targetElement:Element ):void {
			if( element 
				&& targetElement 
				&& element.type == targetElement.type 
				&& ElementUtils.isBlank( targetElement ) ){
				// clear the moving element's parents
				var i:int;
				for( i = 0; i < element.parents.length; i++ ){
					var parent:Element = element.parents.getAt( i );
					ElementUtils.unlinkElements( parent, element );
					generateDefaultDescendentElementsForElement( parent );
				}
				// copy the existing connections from the element to be replaced
				// to the moving element
				for( i = 0; i < targetElement.parents.length; i++ ){
					ElementUtils.linkElements( targetElement.parents.getAt( i ), element );
				}
				for( i = 0; i < targetElement.descendents.length; i++ ){
					ElementUtils.linkElements( element, targetElement.descendents.getAt( i ) );
				}
				// remove the replaced element from the plan
				removeElement( targetElement );
				// if the plan doesn't already contain the moving element, add it
				if( !plan.contains( element ) ){
					plan.addItem( element );					
				}
				// make sure the plan gets re-drawn
				plan.refresh();
			}
		}
		
		/**
		 * Handles a request to pivot on an element in the plan. 
		 */		
		[EventHandler("PlanEvent.PIVOT",properties="element")]
		public function pivot( element:Element=null ):void {
			if( !element ){
				element = presentationModel.selectedElements.getItemAt( 0 ) as Element;
			}
			if( !element ){
				return;
			}
			// clear any previous pivot selection
			unpivot();

			// unset trace mode
			presentationModel.tracePath = false;
			
			// set the pivot element
			presentationModel.pivotElement = element;
			
			// find all the elements we are pivoting on
			presentationModel.pivotElements.source = PivotUtils.getEquivalentElements( element, plan );
		}
		
		/**
		 * Handles a request to exit pivot mode. 
		 */		
		[EventHandler("PlanEvent.UNPIVOT")]
		public function unpivot():void {
			// unset trace mode
			presentationModel.tracePath = false;
			presentationModel.pivotElements.removeAll();
			presentationModel.pivotElement = null;
		}
		
		/**
		 * Handles a request to exit trace mode. 
		 */		
		[EventHandler("PlanEvent.UNTRACE")]
		public function unTracePath():void {
			unpivot();
		}
		
		/**
		 * Handles a request to trace a path on an element in the plan. 
		 */		
		[EventHandler("PlanEvent.TRACE",properties="element")]
		public function tracePath( element:Element=null ):void {
			if( !element && presentationModel.selectedElements.length > 0 ){
				element = presentationModel.selectedElements.getItemAt( 0 ) as Element;
			}
			if( !element ){
				return;
			}
			
			pivot( element );
			// set trace mode
			presentationModel.tracePath = true;
		}
		
		/**
		 * Resets the plan to the blank slate state. 
		 */		
		internal function newPlan():void {
			plan.removeAll();
			createPlanDefaults();
		}
		
		/**
		 * Removes an element and its entire sub-branch from the current plan.
		 * 
		 * @param element The element whose branch you want to remove.
		 */		
		internal function removeBranch( element:Element ):void {
			var elementsToRemove:Array = [ element ];
			var parents:IElementCollection = new ElementCollection( element.parents.toArray() );
			var elementToRemove:Element;
			while( elementsToRemove.length > 0 ){
				elementToRemove = elementsToRemove.shift() as Element;
				elementsToRemove = elementsToRemove.concat( elementToRemove.descendents.toArray() );
				removeElement( elementToRemove );
			}
			for each( element in parents ){
				generateDefaultDescendentElementsForElement( element );
			}
		}
		
		/**
		 * Removes an element from the current plan being worked on.
		 * 
		 * @param element The element to remove from the current plan
		 */
		internal function removeElement( element:Element ):void {
			if( plan ){
				plan.removeItemByIndex( element.elementID );
				var associatedElement:Element;
				var i:int;
				for( i = element.parents.length - 1; i >= 0; i-- ){
					associatedElement = element.parents.getAt( i );
					ElementUtils.unlinkElements( associatedElement, element );
				}
				for( i = element.descendents.length - 1; i >= 0; i-- ){
					associatedElement = element.descendents.getAt( i );
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
					if( existingParentElement.descendents.containsElement( element ) ){
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
				plan.refresh();
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
					default:
						Logger.debug("element type not handled " + element.type);
						break;
				}
				
				// 2. find an existing element of the target type to add the new element to
				if( targetParentType ){
					if( targetElement && ( targetElement.type == targetParentType || ( targetElement.type == ElementType.INTERACTION && element.type == ElementType.INTERACTION ) ) ){
						// 2a. attempt to link the element at the position requested, if there was one
						// and it is already an acceptable position for this element.
						// NOTE: the fancy if condition reflects the fact that you can add interactions to advertisments or interactions
						
						// remove a blank interaction element from this advertisement
						// if we're adding a non-blank interaction
						checkForAndRemoveExistingBlankInteractionIfApplicable( targetElement, element );
						checkForAndReplaceExistingBlankAdvertisementIfApplicable( targetElement, element );
						ElementUtils.linkElements( targetElement, element );
					}else if( targetElement ){
						// 2b. attempt to find a proper place in the branch that the element
						// was requested to be added to when the targetElement itself is not an appropriate parent
						var potentialParents:Array = [];
						var potentialParent:Element;
						
						var relativePosition:int = ElementUtils.sortElementsByType( targetElement, element );
						var appropriateParent:Element;
						if( relativePosition == -1 ){
							// 2bi. search down the branch
							potentialParents = targetElement.descendents.toArray();
							while( potentialParents.length > 0 ){
								potentialParent = potentialParents[0] as Element;
								if( potentialParent.type == targetParentType ){
									appropriateParent = potentialParent;
									break;
								}else{
									potentialParents = potentialParents.concat( potentialParent.descendents.toArray() );
									potentialParents.shift();
								}
							}
						}else if( relativePosition == 1 ){
							// 2bii. search up the branch
							potentialParents = targetElement.parents.toArray();
							while( potentialParents.length > 0 ){
								potentialParent = potentialParents[0] as Element;
								if( potentialParent.type == targetParentType ){
									appropriateParent = potentialParent;
									break;
								}else{
									potentialParents = potentialParents.concat( potentialParent.parents.toArray() );
									potentialParents.shift();
								}
							}							
						}else if( relativePosition == 0 ){
							// 2biii. elements are at the same level, so add the new element to the targetElement's first parent
							if( targetElement.parents.length > 0 ){
								targetElement = targetElement.parents.getAt( 0 );
								appropriateParent = targetElement;
							}
						}
						
						if( appropriateParent ){
							// remove a blank interaction element from this advertisement
							// if we're adding a non-blank interaction
							checkForAndRemoveExistingBlankInteractionIfApplicable( appropriateParent, element );
							checkForAndReplaceExistingBlankAdvertisementIfApplicable( appropriateParent, element );
							ElementUtils.linkElements( appropriateParent, element );
						}else{
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
		 * If the given element or any of its descendent elements currently has no descendents, 
		 * but it should have defaults, this will create and add the appropriate blank descendent
		 * elements for the particular element type.
		 * 
		 * @param element The element you want to generate the default descendents for
		 */
		protected function generateDefaultDescendentElementsForElement( element:Element ):void {
			if( element ){
				var childElement:Element;
				while( element.type.descendentType && element.type.descendentType != element.type ){
					if( element.descendents.length == 0 ){
						childElement = new Element( element.type.descendentType ); // NO PMD
						ElementUtils.linkElements( element, childElement );
						plan.addItem( childElement );
					}else{
						childElement = element.descendents.getAt( 0 );
						if( !plan.contains( childElement ) ){
							plan.addItem( childElement );
						}
					}
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
					checkForAndRemoveExistingBlankInteractionIfApplicable( existingElement, element );
					checkForAndReplaceExistingBlankAdvertisementIfApplicable( existingElement, element );
					ElementUtils.linkElements( existingElement, element );
					break;
				}
			}
		}
		
		/**
		 * Utility function for replacing an existing blank interaction with a
		 * new interaction element on the given parent. This supports all the cases
		 * where we want to actually replace the default blank interaction attached
		 * to an advertisement with a non-blank interaction element.
		 * 
		 * @param parent The parent you are adding the new element to
		 * @param element The element you are adding to the plan
		 */		
		internal function checkForAndRemoveExistingBlankInteractionIfApplicable( parent:Element, element:Element ):void {
			// 1. remove a blank interaction element from this advertisement
			// if we're adding a non-blank interaction
			if( parent.type == ElementType.ADVERTISEMENT 
				&& element.type == ElementType.INTERACTION 
				&& !ElementUtils.isBlank( element ) ){
				for each( var interactionElement:Element in parent.descendents ){
					if( ElementUtils.isBlank( interactionElement ) ){
						removeElement( interactionElement );
						break;
					}
				}
			}
		}
		
		/**
		 * Utility function for replacing an existing blank advertisement with a
		 * new advertisement element on the given parent. This supports all the cases
		 * where we want to actually replace the default blank advertisement attached
		 * to an placement with a non-blank advertisement element.
		 * 
		 * @param parent The parent you are adding the new element to
		 * @param element The element you are adding to the plan
		 */		
		internal function checkForAndReplaceExistingBlankAdvertisementIfApplicable( parent:Element, element:Element ):void {
			// 1. remove a blank advertisement element from this placement
			// if we're adding a non-blank advertisement
			if( parent.type == ElementType.PLACEMENT 
				&& element.type == ElementType.ADVERTISEMENT 
				&& !ElementUtils.isBlank( element ) ){
				for( var i:int = 0; i < parent.descendents.length; i++ ){
					var descendent:Element = parent.descendents.getAt( i );
					if( ElementUtils.isBlank( descendent ) ){
						removeElement( descendent );
						break;
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
package com.velti.monet.controllers {
	import com.velti.monet.events.CampaignEvent;
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	
	/**
	 * Manages the concerns of the represented campaign as a whole.
	 * 
	 * @author Ian Serlin
	 */	
	public class CampaignController {
		
		/**
		 * Handle to the current campaign the user is working on. 
		 */		
		[Inject]
		public var campaign:Campaign;
		
		/**
		 * Constructor 
		 */		
		public function CampaignController() {
		}
		
		/**
		 * Handles a request to start working on a brand new campaign. 
		 */		
		[EventHandler("CampaignEvent.NEW_CAMPAIGN")]
		public function campaign_new( e:CampaignEvent ):void {
			newCampaign();
		}
		
		/**
		 * Handles a request to add an element the campaign. 
		 */		
		[EventHandler("CampaignEvent.ADD_ELEMENT")]
		public function campaign_addElement( e:CampaignEvent ):void {
			addElement( e.element );
		}

		/**
		 * Handles a request to remove an element from the campaign. 
		 */		
		[EventHandler("CampaignEvent.REMOVE_ELEMENT")]
		public function campaign_removeElement( e:CampaignEvent ):void {
			removeElement( e.element );
		}
		
		/**
		 * Resets the campaign to the blank slate state. 
		 */		
		internal function newCampaign():void {
			campaign.removeAll();
			createCampaignDefaults();
		}
		
		/**
		 * Removes an element from the current campaign being worked on.
		 * 
		 * @param element The element to remove from the current campaign
		 */
		internal function removeElement( element:Element ):void {
			if( campaign ){
				campaign.removeItemByIndex( element.elementID );
			}
		}
		
		/**
		 * Adds an element to the current campaign being worked on.
		 * 
		 * @param element The element to add to the current campaign
		 */
		internal function addElement( element:Element ):void {
			if( campaign ){
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
				}
				// 2. find an existing element of the target type to add the new element to
				if( targetParentType ){
					for each( var existingElement:Element in campaign ){
						if( existingElement.type == targetParentType ){
							existingElement.descendents.addItem( element.elementID );
							break;
						}
					}
				}
				// 3. simply add the element to the campaign's collection 
				campaign.addItem( element );
			}
		}
		
		/**
		 * Creates the default set of elements
		 * and adds them to this campaign. 
		 */		
		internal function createCampaignDefaults():void {
			var parentElement:Element = new Element( ElementType.CAMPAIGN );
			var childElement:Element = new Element( ElementType.AUDIENCE );

			parentElement.descendents.addItem( childElement.elementID );
			campaign.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.PUBLISHER );
			parentElement.descendents.addItem( childElement.elementID );
			campaign.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.PLACEMENT );
			parentElement.descendents.addItem( childElement.elementID );
			campaign.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.AD );
			parentElement.descendents.addItem( childElement.elementID );
			campaign.addItem( parentElement );
			
			parentElement = childElement;
			childElement = new Element( ElementType.INTERACTION );
			parentElement.descendents.addItem( childElement.elementID );
			campaign.addItem( parentElement );
			
			campaign.addItem( childElement );
		}
	}
}
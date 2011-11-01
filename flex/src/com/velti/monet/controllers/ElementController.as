package com.velti.monet.controllers
{
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.events.MagicWandEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.InteractionMode;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.views.DialogBase;
	import com.velti.monet.views.elementEditors.AdvertisementEditView;
	import com.velti.monet.views.elementEditors.AudienceEditView;
	import com.velti.monet.views.elementEditors.ElementEditorBase;
	import com.velti.monet.views.elementEditors.InteractionEditView;
	import com.velti.monet.views.elementEditors.PlacementEditView;
	import com.velti.monet.views.elementEditors.PlanEditView;
	import com.velti.monet.views.elementEditors.PublisherEditView;
	
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * Handles element interaction.
	 * 
	 * @author Clint Modien
	 */	
	public class ElementController {
		
		/**
		 * Handle to the global presentation model. 
		 */		
		[Inject]
		public var presentationModel:PresentationModel;
		
		/**
		 * Dispatcher injected by Swiz. 
		 */		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		/**
		 * Handler for when the app gets added to the stage.
		 */        
		[ViewAdded]
		public function appAdded(monet:Monet):void {
			Logger.debug( 'app added to stage' );
			monet.systemManager.stage.addEventListener(KeyboardEvent.KEY_UP, app_keyUp);
		}
		
		/**
		 * Handles the user 'selecting' a particular element within the application. 
		 */
		[EventHandler(event="ElementEvent.SELECT",properties="elements")]
		public function elementRenderer_select( elements:Array ):void {
			if(presentationModel.interactionMode == InteractionMode.MAGIC) {
				if(presentationModel.wandedElement)
					dispatcher.dispatchEvent(new MagicWandEvent(MagicWandEvent.SUBSEQUENT_SELECTED,elements[0] as Element));
				else
					dispatcher.dispatchEvent(new MagicWandEvent(MagicWandEvent.FIRST_SELECTED,elements[0] as Element));
				return;
			}
			if( elements ) {
				presentationModel.selectedElements.removeAll();
				for each( var element:Element in elements ){
					presentationModel.selectedElements.addItem( element );					
				}
			}
		}
		
		/**
		 * Handles the user 'multi-selecting' particular elements within the application. 
		 */
		[EventHandler(event="ElementEvent.ADD_TO_SELECTION",properties="element")]
		public function elementRenderer_addToSelection( e:Element ):void {
			if( e ){
				presentationModel.selectedElements.addItem( e );
			}
		}
		
		/**
		 * Handles the user 'multi-selecting' particular elements within the application. 
		 */
		[EventHandler(event="ElementEvent.REMOVE_FROM_SELECTION",properties="element")]
		public function elementRenderer_removeFromSelection( e:Element ):void {
			if( e ){
				presentationModel.selectedElements.removeItemByIndex( e.elementID );
			}
		}
		
		/**
		 * Deselects all currently selected elements. 
		 */
		[EventHandler(event="ElementEvent.DESELECT")]
		public function elementRenderer_deselect():void {
			presentationModel.selectedElements.removeAll();
		}
		
		/**
		 * Handles the user requesting to show the detailed information for
		 * a particular element in the application. 
		 */
		[EventHandler(event="ElementEvent.SHOW_DETAILS",properties="element")]
		public function elementRenderer_showDetails( element:Element ):void {
			if( element && presentationModel.interactionMode != InteractionMode.MAGIC){
				var dialogBase:DialogBase;
				Logger.debug("showing details for element (" + element.elementID + ") type: " + element.type.name);
				switch( element.type ){
					case ElementType.CAMPAIGN :
						dialogBase = new PlanEditView().show();
						break;
					case ElementType.AUDIENCE :
						dialogBase = new AudienceEditView().show();
						break;
					case ElementType.PUBLISHER :
						dialogBase = new PublisherEditView().show();
						break;
					case ElementType.PLACEMENT :
						dialogBase = new PlacementEditView().show();
						break;
					case ElementType.ADVERTISEMENT :
						dialogBase = new AdvertisementEditView().show();
						break;
					case ElementType.INTERACTION :
						dialogBase = new InteractionEditView().show();
						break;
					default:
						Logger.debug("element ("+ element.elementID +") type not found: " + element.type.name)
				}
				var elementEditor:ElementEditorBase = dialogBase as ElementEditorBase;
				if(elementEditor) elementEditor.element = element;
			}
		}
		
		/**
		 * Handles the user pressing a key while in the app. 
		 */		
		protected function app_keyUp( event:KeyboardEvent ):void {
			if( event.keyCode == Keyboard.BACKSPACE || event.keyCode == Keyboard.DELETE ){
				removeCurrentlySelectedElement();
			}
		}
		
		/**
		 * Requests to remove the currently selected element and all 
		 * of its sub branches from the current plan. 
		 */		
		protected function removeCurrentlySelectedElement():void {
			for each( var element:Element in presentationModel.selectedElements ){
				if( element && element.type != ElementType.CAMPAIGN ){
					Logger.debug( 'removing element and branch: ' + element.elementID );
					var elementToBeRemoved:Element = element;
					presentationModel.selectedElements.removeItemByIndex( elementToBeRemoved );
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.REMOVE_BRANCH, elementToBeRemoved ) );
				}
			}
		}
		
	}
}
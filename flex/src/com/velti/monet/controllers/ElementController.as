package com.velti.monet.controllers
{
	import com.velti.monet.events.ElementRendererEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.views.DialogBase;
	import com.velti.monet.views.Key;
	import com.velti.monet.views.elementEditors.AdvertisementEditView;
	import com.velti.monet.views.elementEditors.AudienceEditView;
	import com.velti.monet.views.elementEditors.ElementEditorBase;
	import com.velti.monet.views.elementEditors.InteractionEditView;
	import com.velti.monet.views.elementEditors.PlanEditView;
	import com.velti.monet.views.elementEditors.PublisherPlacementEditView;
	
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
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
			trace( 'app added to stage' );
			monet.systemManager.stage.addEventListener(KeyboardEvent.KEY_UP, app_keyUp);
		}
		
		/**
		 * Handles the user 'selecting' a particular element within the application. 
		 */		
		[EventHandler("ElementRendererEvent.SELECT")]
		public function elementRenderer_select( e:ElementRendererEvent ):void {
			if( e.element ){
				presentationModel.selectedElement = e.element;
			}else{
				presentationModel.selectedElement = null;
			}
		}
		
		/**
		 * Handles the user requesting to show the detailed information for
		 * a particular element in the application. 
		 */		
		[EventHandler("ElementRendererEvent.SHOW_DETAILS")]
		public function elementRenderer_showDetails( e:ElementRendererEvent ):void {
			if( e.element ){
				var dialogBase:DialogBase;
				trace("showing details for element (" + e.element.elementID + ") type: " + e.element.type.name);
				switch( e.element.type ){
					case ElementType.CAMPAIGN :
						dialogBase = new PlanEditView().show();
						break;
					case ElementType.AUDIENCE :
						dialogBase = new AudienceEditView().show();
						break;
					case ElementType.PUBLISHER :
						dialogBase = new PublisherPlacementEditView().show();
						break;
					case ElementType.PLACEMENT :
						dialogBase = new PublisherPlacementEditView().show();
						break;
					case ElementType.ADVERTISEMENT :
						dialogBase = new AdvertisementEditView().show();
						break;
					case ElementType.INTERACTION :
						dialogBase = new InteractionEditView().show();
						break;
					default:
						trace("element ("+ e.element.elementID +") type not found: " + e.element.type.name)
				}
				var elementEditor:ElementEditorBase = dialogBase as ElementEditorBase;
				if(elementEditor) elementEditor.element = e.element;
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
			if( presentationModel.selectedElement && presentationModel.selectedElement.type != ElementType.CAMPAIGN ){
				trace( 'removing element and branch: ' + presentationModel.selectedElement.elementID );
				var elementToBeRemoved:Element = presentationModel.selectedElement;
				presentationModel.selectedElement = null;
				dispatcher.dispatchEvent( new PlanEvent( PlanEvent.REMOVE_BRANCH, elementToBeRemoved ) );
			}
		}
		
	}
}
package com.velti.monet.controllers
{
	import com.velti.monet.controls.ElementRenderer;
	import com.velti.monet.events.ElementRendererEvent;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.views.elementEditors.AudienceEditView;
	import com.velti.monet.views.elementEditors.ContentEditView;
	import com.velti.monet.views.elementEditors.InteractionEditView;
	import com.velti.monet.views.elementEditors.PlanEditView;
	import com.velti.monet.views.elementEditors.PublisherPlacementEditView;
	
	import flash.events.MouseEvent;
	
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
				trace("showing details for element (" + e.element.elementID + ") type: " + e.element.type.name);
				switch( e.element.type ){
					case ElementType.CAMPAIGN :
						new PlanEditView().show();
						break;
					case ElementType.AUDIENCE :
						new AudienceEditView().show();
						break;
					case ElementType.PUBLISHER :
						new PublisherPlacementEditView().show();
						break;
					case ElementType.PLACEMENT :
						new PublisherPlacementEditView().show();
						break;
					case ElementType.AD :
						new ContentEditView().show();
						break;
					case ElementType.INTERACTION :
						new InteractionEditView().show();
						break;
					default:
						trace("element ("+ e.element.elementID +") type not found: " + e.element.type.name)
				}
			}
		}
	}
}
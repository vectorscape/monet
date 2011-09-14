package com.velti.monet.controllers
{
	import com.velti.monet.events.ElementRendererEvent;
	import com.velti.monet.models.ElementConsts;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.views.DialogBase;
	
	/**
	 * Handles element interaction.
	 * 
	 * @author Clint Modien
	 */	
	public class ElementController 
	{		
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
			var constData:ElementConsts = ElementConsts.getConst(e.element);
			var dialog:DialogBase =  new constData.editDialog();
			dialog.show();
		}
	}
}
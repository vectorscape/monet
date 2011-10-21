package com.velti.monet.controllers {
	import com.velti.monet.models.InteractionMode;
	import com.velti.monet.models.PresentationModel;

	/**
	 * Controller class that deals
	 * with managing the interaction modes
	 * of the application, could also probably
	 * be called "ApplicationController".
	 * 
	 * @author Ian Serlin
	 */	
 	public class InteractionController {
		
		/**
		 * Handle to the global presentation model. 
		 */		
		[Inject]
		public var presentationModel:PresentationModel;
		
		/**
		 * Handles a request to change the interaction mode in the application. 
		 */		
		[EventHandler("InteractionModeEvent.CHANGE",properties="interactionMode")]
		public function interactionMode_change( interactionMode:InteractionMode ):void {
			if( interactionMode ){
				presentationModel.interactionMode = interactionMode;
				trace( "changed interaction mode to: " + interactionMode.name );
			}
		}
		
	}
}
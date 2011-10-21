package com.velti.monet.events {
	import com.velti.monet.models.InteractionMode;
	
	/**
	 * Event class that deals with changing interaction modes of the application.
	 *  
	 * @author Ian Serlin
	 */	
	public class InteractionModeEvent extends BaseEvent {

		/**
		 * Event type to dispatch when you want to change the interaction mode.
		 * 
		 * NOTE: you must put the desired interaction type into the 
		 * "interactionMode" property.
		 */		
		public static const CHANGE:String = "change";
		
		/**
		 * Interaction mode associated with this event. 
		 */		
		public function get interactionMode():InteractionMode {
			return _interactionMode;
		}
		/**
		 * @private 
		 */		
		private var _interactionMode:InteractionMode;
		
		/**
		 * Constuctor. 
		 */		
		public function InteractionModeEvent(type:String, interactionMode:InteractionMode=null, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this._interactionMode = interactionMode;
		}
	}
}
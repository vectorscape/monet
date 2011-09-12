package com.velti.monet.models {
	
	/**
	 * Presentation model containing global variables
	 * that affect the display of the application.
	 *  
	 * @author Ian Serlin
	 */	
	public class PresentationModel {
		
		/**
		 * True if the user wants the swim lanes to be drawn in the 
		 * normal campaign diagram view, false otherwise. 
		 */		
		[Bindable]
		public var showSwimLanes:Boolean = false;
		
		/**
		 * True if the user wants the connections between elements in the
		 * campaign they are working on to be right-angled, false otherwise. 
		 */		
		[Bindable]
		public var useAngeledConnections:Boolean = true;
	}
}
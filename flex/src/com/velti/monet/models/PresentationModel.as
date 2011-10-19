package com.velti.monet.models {
	import com.velti.monet.collections.IndexedCollection;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Presentation model containing global variables
	 * that affect the display of the application.
	 *  
	 * @author Ian Serlin
	 */	
	public class PresentationModel 
	{
		/**
		 * Whether or not the plan has been submitted yet.
		 */
		[Bindable]
		public var planSubmitted:Boolean = false;
		
		/**
		 * The zoom level of the diagram view. 
		 */		
		[Bindable]
		public var zoomLevel:Number = 1;
		
		/**
		 * True if the user wants the swim lanes to be drawn in the 
		 * normal plan diagram view, false otherwise. 
		 */		
		[Bindable]
		public var showSwimLanes:Boolean = false;
		
		/**
		 * True if the user wants the connections between elements in the
		 * plan they are working on to be right-angled, false otherwise. 
		 */		
		[Bindable]
		public var useAngeledConnections:Boolean = true;
		
		/**
		 * Handle to the currently selected element. 
		 */		
		[Bindable]
		public var selectedElements:IndexedCollection = new IndexedCollection("elementID");
		
		/**
		 * Handle to the set of elements that we are "pivoting" on. 
		 */		
		[Bindable]
		public var pivotElements:IndexedCollection = new IndexedCollection("elementID");
		
		/**
		 * The original pivot element the user wanted to pivot on. 
		 */		
		[Bindable]
		public var pivotElement:Element;
		
		/**
		 * The list of age ranges for an Audience element type. 
		 */		
		[Bindable]
		public var ageRanges:ArrayCollection = new ArrayCollection([
			"13-17",
			"18-24",
			"25-34",
			"35-44",
			"45-54",
			"55-64",
			"65+"
		]);
	}
}
package com.velti.monet.models {
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
		public var selectedElement:Element;
		
		[Bindable]
		public var publishersAndPlacements:XML =  <root>
				<node label="CNN">
					<node label="Any" />
					<node label="Home Page"  />
					<node label="Basketball hub"  />
					<node label="Baseball hub"  />
					<node label="NFL hub"  />
					<node label="Soccer hub"  />
				</node>
				<node label="ESPN">
					<node label="Any"  />
					<node label="Home Page"  />
					<node label="NBA hub"  />
					<node label="MLB hub"  />
					<node label="NFL hub"  />
					<node label="Soccer hub"  />
				</node>
				<node label="TMZ">
					<node label="Any"  />
					<node label="Home Page"  />
					<node label="Contest Page"  />
					<node label="Baseball hub"  />
					<node label="NFL hub"  />
					<node label="Soccer hub"  />
				</node>
				<node label="Washington Post">
					<node label="Any" />
					<node label="Revolution Hub" />
				</node>
			</root>;
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
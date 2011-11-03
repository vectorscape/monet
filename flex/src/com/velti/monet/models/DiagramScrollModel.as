package com.velti.monet.models {
	
	/**
	 * Model to support the drag scroller/navigator
	 * function.
	 *  
	 * @author Ian Serlin
	 */
	public class DiagramScrollModel {
		
		/**
		 * Horizontal scroll position of the plan diagram. 
		 */
		[Bindable]
		public var scrollX:Number = 0;
		
		/**
		 * Vertical scroll position of the plan diagram. 
		 */
		[Bindable]
		public var scrollY:Number = 0;
		
		/**
		 * Width of the plan diagram. 
		 */
		[Bindable]
		public var diagramWidth:Number = 0;
		
		/**
		 * Height of the plan diagram. 
		 */
		[Bindable]
		public var diagramHeight:Number = 0;
		
		/**
		 * Width of the plan diagram's viewport. 
		 */
		[Bindable]
		public var viewportWidth:Number = 0;
		
		/**
		 * Height of the plan diagram's viewport. 
		 */
		[Bindable]
		public var viewportHeight:Number = 0;
		
	}
}
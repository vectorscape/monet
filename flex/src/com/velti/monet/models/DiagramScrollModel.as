package com.velti.monet.models {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.FlexBitmap;
	
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
		 * Max horizontal scroll position of the plan diagram. 
		 */
		[Bindable]
		public var maxScrollX:Number = 0;
		
		/**
		 * Max vertical scroll position of the plan diagram. 
		 */
		[Bindable]
		public var maxScrollY:Number = 0;
		
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
		
		/**
		 * The Bitmap snapshot of the current diagram. 
		 */		
		[Bindable]
		public var thumbnail:Bitmap = new Bitmap();

		/**
		 * Min width of the thumbnail snapshot. 
		 */		
		[Bindable]
		public var minThumbnailWidth:Number = 120;
		
		/**
		 * Min height of the thumbnail snapshot. 
		 */		
		[Bindable]
		public var minThumbnailHeight:Number = 150;

		/**
		 * Max width of the thumbnail snapshot. 
		 */		
		[Bindable]
		public var maxThumbnailWidth:Number = 160;
		
		/**
		 * Max height of the thumbnail snapshot. 
		 */		
		[Bindable]
		public var maxThumbnailHeight:Number = 160;

		/**
		 * Actual width of the thumbnail snapshot. 
		 */		
		[Bindable]
		public var thumbnailWidth:Number = 120;
		
		/**
		 * Actual height of the thumbnail snapshot. 
		 */		
		[Bindable]
		public var thumbnailHeight:Number = 150;
		
		/**
		 * Scale factor used to create the thumbnail snapshot
		 * horizontally. 
		 */		
		[Bindable]
		public var scaleFactorX:Number = 1;
		
		/**
		 * Scale factor used to create the thumbnail snapshot
		 * vertically. 
		 */		
		[Bindable]
		public var scaleFactorY:Number = 1;
		
	}
}
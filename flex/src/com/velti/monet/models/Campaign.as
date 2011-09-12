package com.velti.monet.models {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.collections.IInteractionCollection;
	import com.velti.monet.collections.IContentCollection;
	import com.velti.monet.collections.IPlacementsCollection;
	import com.velti.monet.collections.IPublisherCollection;
	
	/**
	 * Model that represents an entire campaign as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Campaign extends IndexedCollection {
		
		public var name:String = "";
		public var brand:Brand;
		public var startDate:Date;
		public var endDate:Date;
		public var budget:Number;
		public var description:String = "";
		
		public var audience:Audience;
		public var publishers:IPublisherCollection;
		public var placements:IPlacementsCollection;
		public var content:IContentCollection;
		public var interactions:IInteractionCollection;
		
		/**
		 * Constructor.
		 * 
		 * Creates a new Campaign containing
		 * the default set of elements. 
		 */		
		public function Campaign() {
			super("elementID");
		}
		
		/**
		 * Overriden to always set the default. 
		 */		
		override public function set indexedProperty(value:String):void {
			super.indexedProperty = "elementID";
		}
		
	}
}
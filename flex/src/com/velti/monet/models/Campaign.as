package com.velti.monet.models {
	import com.velti.monet.collections.IndexedCollection;

	/**
	 * Model that represents an entire campaign as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Campaign extends IndexedCollection {

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
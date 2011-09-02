package com.velti.monet.models {
	import com.velti.monet.collections.IndexedCollection;

	/**
	 * 
	 * @author Ian Serlin
	 */	
	public class Campaign {

		/**
		 * The set of elements modeled
		 * by this campaign.
	 	 */		
		public function get elements():IndexedCollection {
			return _elements;
		}
		public function set elements(value:IndexedCollection):void {
			_elements = value;
		}
		/**
		 * @private 
		 */		
		private var _elements:IndexedCollection;
		
		/**
		 * Constructor.
		 * 
		 * Creates a new Campaign containing
		 * the default set of elements. 
		 */		
		public function Campaign() {
			_elements = new IndexedCollection("uid");
			createDefaults();
		}
		
		/**
		 * Creates the default set of elements
		 * and adds them to this campaign. 
		 */		
		internal function createDefaults():void {
			_elements.addItem( new Element( ElementType.AUDIENCE ) );
			_elements.addItem( new Element( ElementType.PUBLISHER ) );
			_elements.addItem( new Element( ElementType.PLACEMENT ) );
			_elements.addItem( new Element( ElementType.CONTENT ) );
			_elements.addItem( new Element( ElementType.INTERACTION ) );
		}

	}
}
package com.velti.monet.models {
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	/**
	 * 
	 * @author Ian Serlin
	 */	
	public class Campaign {

		/**
		 * The set of elements modeled
		 * by this campaign.
	 	 */		
		public function get elements():IList {
			return _elements;
		}
		public function set elements(value:IList):void {
			_elements = value;
		}
		/**
		 * @private 
		 */		
		private var _elements:IList;
		
		/**
		 * Constructor.
		 * 
		 * Creates a new Campaign containing
		 * the default set of elements. 
		 */		
		public function Campaign() {
			_elements = new ArrayCollection();
			createDefaults();
		}
		
		/**
		 * Creates the default set of elements
		 * and adds them to this campaign. 
		 */		
		internal function createDefaults():void {
			_elements.addItem( new Element( ElementTypes.AUDIENCE ) );
			_elements.addItem( new Element( ElementTypes.PUBLISHER ) );
			_elements.addItem( new Element( ElementTypes.PLACEMENT ) );
			_elements.addItem( new Element( ElementTypes.CONTENT ) );
			_elements.addItem( new Element( ElementTypes.RESULTS ) );
		}

	}
}
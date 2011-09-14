package com.velti.monet.models 
{
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.utils.PlanUtils;
	
	import mx.collections.ListCollectionView;
	
	/**
	 * Model that represents an entire plan as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Plan extends IndexedCollection 
	{
		public var name:String = "";
		public var brand:Brand;
		public var startDate:Date;
		public var endDate:Date;
		public var budget:Number;
		public var description:String = "";
		
		public var audience:Audience;
		public var publishers:Array;
		public var placements:Array;
		public var content:Array;
		public var interactions:Array;
		
		/**
		 * @private 
		 */		
		private var _audiences:ListCollectionView;
		/**
		 * Collection of audiences represented by this plan. 
		 */		
		public function get audiences():ListCollectionView {
			return _audiences;
		}
		
		/**
		 * @private 
		 */		
		private var _plans:ListCollectionView;
		/**
		 * Collection of plans represented by this plan. 
		 */		
		public function get plans():ListCollectionView {
			return _plans;
		}
		
		/**
		 * Constructor.
		 * 
		 * Creates a new Plan containing
		 * the default set of elements. 
		 */		
		public function Plan() {
			super("elementID");
			_audiences = new ListCollectionView( this );
			_audiences.filterFunction = PlanUtils.filterAudiencesOnly;
			_audiences.refresh();
			
			_plans = new ListCollectionView( this );
			_plans.filterFunction = PlanUtils.filterPlansOnly;
			_plans.refresh();

		}
		
		/**
		 * Overriden to always set the default. 
		 */		
		override public function set indexedProperty(value:String):void {
			super.indexedProperty = "elementID";
		}

		/**
		 * Retrieves an array of the elements which are direct next-level descendents
		 * of the given element.
		 * 
		 * @param element The Element whose descendent Element instances you want
		 * @return an array of elements that are the direct next-level descendents of the give element 
		 */		
		public function getDescendentElementsOfElement( element:Element ):Array {
			var elements:Array = [];
			var descendentElement:Element;
			for each( var elementID:String in element.descendents ){
				descendentElement = this.getItemByIndex( elementID ) as Element;
				if( descendentElement ){
					elements.push( descendentElement );
				}
			}
			return elements;
		}
	}
}
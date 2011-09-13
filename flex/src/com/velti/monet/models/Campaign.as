package com.velti.monet.models 
{
	import com.velti.monet.collections.IContentCollection;
	import com.velti.monet.collections.IInteractionCollection;
	import com.velti.monet.collections.IPlacementsCollection;
	import com.velti.monet.collections.IPublisherCollection;
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.utils.CampaignUtils;
	
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	
	/**
	 * Model that represents an entire campaign as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Campaign extends IndexedCollection 
	{
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
		 * @private 
		 */		
		private var _audiences:ListCollectionView;
		/**
		 * Collection of audiences represented by this campaign. 
		 */		
		public function get audiences():ListCollectionView {
			return _audiences;
		}
		
		/**
		 * @private 
		 */		
		private var _campaigns:ListCollectionView;
		/**
		 * Collection of campaigns represented by this plan. 
		 */		
		public function get campaigns():ListCollectionView {
			return _campaigns;
		}
		
		/**
		 * Constructor.
		 * 
		 * Creates a new Campaign containing
		 * the default set of elements. 
		 */		
		public function Campaign() {
			super("elementID");
			_audiences = new ListCollectionView( this );
			_audiences.filterFunction = CampaignUtils.filterAudiencesOnly;
			_audiences.refresh();
			
			_campaigns = new ListCollectionView( this );
			_campaigns.filterFunction = CampaignUtils.filterCampaignsOnly;
			_campaigns.refresh();

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
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
	[RemoteClass]
	public class Plan extends IndexedCollection implements ISerializable 
	{
		/**
		 * @private 
		 */		
		internal var _audiences:ListCollectionView = new ListCollectionView();
		/**
		 * @private 
		 */		
		internal var _campaigns:ListCollectionView = new ListCollectionView();
		
		/**
		 * Collection of audiences represented by this plan. 
		 */		
		public function get audiences():ListCollectionView {
			return _audiences;
		}
		
		/**
		 * Collection of plans represented by this plan. 
		 */
		public function get campaigns():ListCollectionView {
			return _campaigns;
		}
		/**
		 * Constructor.
		 * 
		 * Creates a new Plan containing
		 * the default set of elements. 
		 */		
		public function Plan() {
			super("elementID");
			
			audiences.list = this;
			audiences.filterFunction = PlanUtils.filterAudiencesOnly;
			audiences.refresh();
			
			campaigns.list = this;
			campaigns.filterFunction = PlanUtils.filterPlansOnly;
			campaigns.refresh();
		}
		
		/**
		 * Overriden to always set the default. 
		 */		
		override public function set indexedProperty(value:String):void { // NO PMD
			super.indexedProperty = "elementID";
		}
		/**
		 * Used to check whether all the elements of a certain
		 * type are complete.
		 */		
		[Bindable(event="collectionChange")]
		public function isElementTypesComplete(elementTypes:Array):Boolean {
			var returnVal:Boolean = true;
			for each (var item:Element in this) {
				if(elementTypes.indexOf(item.type) != -1 && !item.data.isValid) {
					returnVal = false;
					break;
				}
			}
			return returnVal;
		}
	}
}
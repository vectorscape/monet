package com.velti.monet.models 
{
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.utils.PlanUtils;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectUtil;
	
	/**
	 * Model that represents an entire plan as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */
	[RemoteClass]
	public class Plan extends IndexedCollection implements ISerializable, ICloneable 
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
		
		/**
		 * Retrieves an array of the elements which are direct previous-level parent
		 * of the given element.
		 * 
		 * @param element The Element whose parent Element instances you want
		 * @return an array of elements that are the direct previous-level parents of the give element 
		 */		
		public function getParentElementsOfElement( element:Element ):Array {
			var elements:Array = [];
			var parentElement:Element;
			for each( var elementID:String in element.parents ){
				parentElement = this.getItemByIndex( elementID ) as Element;
				if( parentElement ){
					elements.push( parentElement );
				}
			}
			return elements;
		}
		
		/**
		 * Clones this object
		 * @return 
		 * 
		 */		
		public function clone():ICloneable
		{
			return ObjectUtil.copy(this) as ICloneable;
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
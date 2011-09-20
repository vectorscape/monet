package com.velti.monet.models 
{
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.models.elementData.CampaignElementData;
	import com.velti.monet.utils.PlanUtils;
	
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.collections.ListCollectionView;
	import mx.utils.UIDUtil;
	
	/**
	 * Model that represents an entire plan as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */
	[RemoteClass]
	public class Plan extends IndexedCollection implements ISerializable2, ICloneable, IExternalizable 
	{	
		public var planID:String;
		
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
		private var _campaigns:ListCollectionView;
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
			
			//register the class alias so 
			//we can serialize deserialze from AMF
			
			_audiences = new ListCollectionView( this );
			_audiences.filterFunction = PlanUtils.filterAudiencesOnly;
			_audiences.refresh();
			
			_campaigns = new ListCollectionView( this );
			_campaigns.filterFunction = PlanUtils.filterCampaignsOnly;
			_campaigns.refresh();
			
			this.planID 	= planID && planID != '' ? planID : UIDUtil.createUID();
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
		
		override public function toString():String {
			return CampaignElementData(campaigns[0].data).name;
		}
		
		public function load(p:Plan):void {
			this.planID = p.planID;
			this.removeAll();
			this.addAll(p);
			this.refresh();
		}
		
		/**
		 * Deserializes this objects properties
		 */
		override public function readExternal(input:IDataInput):void {
			var obj:Object = input.readObject();
			this.source = obj.source as Array;
			this.indexedProperty = obj.indexedProperty as String;
			this.planID = obj.planID as String;
		}
		
		/**
		 * Serializes this objects properties
		 */
		override public function writeExternal(output:IDataOutput):void {
			output.writeObject({
				source:source,
				indexedProperty:indexedProperty,
				planID:planID
			});
		}
	}
}
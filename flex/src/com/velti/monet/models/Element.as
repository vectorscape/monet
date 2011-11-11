package com.velti.monet.models 
{
	import com.velti.monet.collections.ElementCollection;
	import com.velti.monet.collections.IElementCollection;
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.models.elementData.AdvertisementElementData;
	import com.velti.monet.models.elementData.AudienceElementData;
	import com.velti.monet.models.elementData.CampaignElementData;
	import com.velti.monet.models.elementData.ElementData;
	import com.velti.monet.models.elementData.InteractionElementData;
	import com.velti.monet.models.elementData.KeyElementData;
	import com.velti.monet.models.elementData.PlacementElementData;
	import com.velti.monet.models.elementData.PublisherElementData;
	
	import flash.events.Event;
	
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.UIDUtil;
	
	/**
	 * @see com.velti.monet.events.ElementEvent#DESCENDENTS_CHANGED 
	 */	
	[Event(name="descendentsChanged", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	/**
	 * @see com.velti.monet.events.ElementEvent#PARENTS_CHANGED 
	 */	
	[Event(name="parentsChanged", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	/**
	 * Dispatched when the data property changes. 
	 */	
	[Event(name="dataChange", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	
	/**
	 * Represents one element or node in the
	 * plan graph.
	 * 
	 * @author Ian Serlin
	 */	
	[RemoteClass]
	public class Element extends DataObject {		
		/**
		 * The label to display that visually
		 * describes this element.
		 */
		[Bindable]
		public function get elementID():String {
			return _elementID;
		}
		public function set elementID( value:String ):void {
			if( _elementID != value ){
				_elementID = value;
			}
		}
		/**
		 * @private 
		 */		
		protected var _elementID:String;
		
		/**
		 * The type of element this instance
		 * represents, one of the valid values
		 * from <code>ElementType</code>.  
		 */	
		[Bindable]
		public function get type():ElementType {
			return _type;
		} public function set type(v:ElementType):void {
			if(!v) v = ElementType.NONE;
			_type = v;
			data = getDataForType(v,this);
		}
		/**
		 * @private
		 */
		internal var _type:ElementType = ElementType.NONE;
		
		private function data_anyPropChange(event:Event):void {
			dispatchEvent(new Event(ElementEvent.DATA_CHANGE));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"data",null,data));
		} 
		/**
		 * The properties of the Element
		 */
		[Bindable(event="dataChange")]
		public function get data():ElementData {
			return _data;
		}
		public function set data( value:ElementData ):void {
			if( _data != value ){
				if(_data) _data.removeEventListener(ElementData.ANY_PROP_CHANGE,data_anyPropChange);
				_data = value;
				wireData();
			}
		}
		/**
		 * @private 
		 */		
		internal var _data:ElementData;
		
		/**
		 * Wires up the necessary initialization when
		 * we are receiving a new ElementData instance. 
		 */		
		protected function wireData():void {
			_data.addEventListener(ElementData.ANY_PROP_CHANGE,data_anyPropChange,false,0,true);
			dispatchEvent(new Event(ElementEvent.DATA_CHANGE));
		}
		
		/**
		 * The label to display that visually
		 * describes this element.
		 */
		[Bindable(event="dataChange")]
		public function get label():String {
			return data.labelString;
		}
		public function set label( value:String ):void {
			if(!data) _data = ElementData.NO_ELEMENT_DATA;
			data.labelString = value;
			dispatchEvent(new Event(ElementEvent.DATA_CHANGE));
		}
		
		/**
		 * @private 
		 */		
		private var _descendents:IElementCollection;
		
		/**
		 * A set of elementIDs of the Elements that
		 * this Element points to.
		 */
		[Bindable]
		public function get descendents():IElementCollection {
			if( !_descendents ){
				_descendents = new ElementCollection();
			}
			return _descendents;
		}
		
		/**
		 * @private
		 */
		public function set descendents(value:IElementCollection):void {
			if( value != _descendents ){
				if( _descendents ){
					_descendents.removeEventListener(CollectionEvent.COLLECTION_CHANGE, descendents_collectionChange);
				}
				_descendents = value;
				if( _descendents ){
					_descendents.addEventListener(CollectionEvent.COLLECTION_CHANGE, descendents_collectionChange);
				}
				dispatchDescendentsChanged();
			}
		}
		
		/**
		 * @private 
		 */		
		private var _parents:IElementCollection;
		
		/**
		 * A set of elementIDs of the Elements that
		 * this Element points to.
		 */
		[Bindable]
		public function get parents():IElementCollection {
			if( !_parents ){
				_parents = new ElementCollection();
			}
			return _parents;
		}
		
		/**
		 * @private
		 */
		public function set parents(value:IElementCollection):void {
			if( value != _parents ){
				if( _parents ){
					_parents.removeEventListener(CollectionEvent.COLLECTION_CHANGE, parents_collectionChange);
				}
				_parents = value;
				if( _parents ){
					_parents.addEventListener(CollectionEvent.COLLECTION_CHANGE, parents_collectionChange);
				}
				dispatchParentsChanged();
			}
		}
		
		/**
		 * Current status of this element.
		 *  
		 * @see com.velti.monet.controls.elementClasses.ElementStatus
		 */
		public function get status():ElementStatus{
			return data.isValid ? ElementStatus.COMPLETE : ElementStatus.INCOMPLETE;
		}
		
		/**
		 * True if this element should be treated as a isTemplate element.
		 */		
		public var isTemplate:Boolean = false;
		
		/**
		 * Constructor 
		 */		
		public function Element( type:ElementType = null, label:String=null, elementID:String=null, isTemplate:Boolean=false ) {
			super();
			this.type 		= type || ElementType.NONE;
			this.label 		= label;
			this.elementID 	= elementID && elementID != '' ? elementID : UIDUtil.createUID();
			this.isTemplate = isTemplate;
		}
		
		/**
		 * Handles this Element's descendents being updated. 
		 */		
		protected function descendents_collectionChange(event:CollectionEvent):void {
			dispatchDescendentsChanged();
		}
		
		/**
		 * Dispatches an ElementEvent.DESCENDENTS_CHANGED event. 
		 */		
		protected function dispatchDescendentsChanged():void {
			dispatchEvent( new ElementEvent( ElementEvent.DESCENDENTS_CHANGED ) );
		}
		
		/**
		 * Handles this Element's parents being updated. 
		 */		
		protected function parents_collectionChange(event:CollectionEvent):void {
			dispatchParentsChanged();
		}
		
		/**
		 * Dispatches an ElementEvent.PARENTS_CHANGED event. 
		 */		
		protected function dispatchParentsChanged():void {
			dispatchEvent( new ElementEvent( ElementEvent.PARENTS_CHANGED ) );
		}
		/**
		 * A helper method to get element data based on an element type. 
		 * @param v The type of data to get.
		 * @return A data object for the type.
		 * 
		 */		
		private static function getDataForType(v:ElementType, e:Element):ElementData {
			var returnVal:ElementData;
			switch (v) {
				case ElementType.CAMPAIGN :
					returnVal = new CampaignElementData();
					break;
				case ElementType.AUDIENCE :
					returnVal = new AudienceElementData();
					break;
				case ElementType.PUBLISHER :
					returnVal = new PublisherElementData();
					break;
				case ElementType.PLACEMENT :
					returnVal = new PlacementElementData();
					PlacementElementData(returnVal).element = e;
					break;
				case ElementType.ADVERTISEMENT :
					returnVal = new AdvertisementElementData();
					break;
				case ElementType.INTERACTION :
					returnVal = new InteractionElementData();
					break;
				case ElementType.KEY :
					returnVal = new KeyElementData();
					break;
				default:
					returnVal = ElementData.NO_ELEMENT_DATA;
					break;
			}
			return returnVal;
		}
	}
}
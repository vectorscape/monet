package com.velti.monet.models 
{
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.models.elementData.ElementData;
	
	import flash.events.Event;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.utils.UIDUtil;
	
	/**
	 * @see com.velti.monet.events.ElementEvent#DESCENDENTS_CHANGED 
	 */	
	[Event(name="descendentsChanged", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	/**
	 * Dispatched when the data property changes. 
	 */	
	[Event(name="dataChanged", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	
	/**
	 * Represents one element or node in the
	 * plan graph.
	 * 
	 * @author Ian Serlin
	 */	
	[RemoteClass]
	public class Element extends DataObject 
	{
		public static const DATA_CHANGED:String = "dataChanged";
		
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
			if(_data) _data.removeEventListener(DATA_CHANGED,data_dataChanged);
			_data = ElementData.getDataForType(v);
			_data.addEventListener(DATA_CHANGED,data_dataChanged,false,0,true);
			dispatchEvent(new Event(DATA_CHANGED));
		}internal var _type:ElementType = ElementType.NONE;
		
		private function data_dataChanged(event:Event):void {
			dispatchEvent(new Event(DATA_CHANGED));
		} 
		/**
		 * The properties of the Element
		 */
		[Bindable(event="dataChanged")]
		public function get data():ElementData {
			return _data;
		} internal var _data:ElementData;
		
		/**
		 * The label to display that visually
		 * describes this element.
		 */
		[Bindable(event="dataChanged")]
		public function get label():String {
			return data.labelString;
		}
		public function set label( value:String ):void {
			if(!data) _data = ElementData.NO_ELEMENT_DATA;
			data.labelString = value;
			dispatchEvent(new Event(DATA_CHANGED));
		}
		
		/**
		 * @private 
		 */		
		private var _descendents:ArrayCollection;
		
		/**
		 * A set of elementIDs of the Elements that
		 * this Element points to.
		 */
		[Bindable]
		public function get descendents():ArrayCollection {
			if( !_descendents ){
				_descendents = new ArrayCollection();
			}
			return _descendents;
		}
		
		/**
		 * @private
		 */
		public function set descendents(value:ArrayCollection):void {
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
		 * Current status of this element.
		 *  
		 * @see com.velti.monet.controls.elementClasses.ElementStatus
		 */
		public var status:ElementStatus;
		
		/**
		 * True if this element should be treated as a isTemplate element.
		 */		
		public var isTemplate:Boolean = false;
		
		/**
		 * Constructor 
		 */		
		public function Element( type:ElementType = null, label:String=null, elementID:String=null, status:ElementStatus=null, isTemplate:Boolean=false ) {
			super();
			if(!type) type = ElementType.NONE;
			this.type 		= type;
			this.label 		= label;
			this.elementID 	= elementID && elementID != '' ? elementID : UIDUtil.createUID();
			this.status 	= status ? status : ElementStatus.INCOMPLETE;
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
		 * Returns a list of properties (getters and vars) for this object
		 */
		public function get propertyList():Array {
			var returnVal:Array = [];
			var node:XML;
			var list:XMLList;
			var xml:XML = describeType(this);
			list = xml..accessor;
			for each(node in list) {
				returnVal.push(node.@name);
			}
			list = xml..variable;
			for each(node in list) {
				returnVal.push(node.@name);
			}
			return returnVal;
		}
	}
}
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
			_type = v;
			if(_data) _data.removeEventListener(DATA_CHANGED,data_dataChanged);
			_data = ElementData.getDataForType(v);
			_data.addEventListener(DATA_CHANGED,data_dataChanged,false,0,true);
			dispatchEvent(new Event(DATA_CHANGED));
		}internal var _type:ElementType;
		
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
		 * @private 
		 */		
		private var _parents:ArrayCollection;
		
		/**
		 * A set of elementIDs of the Elements that
		 * this Element points to.
		 */
		[Bindable]
		public function get parents():ArrayCollection {
			if( !_parents ){
				_parents = new ArrayCollection();
			}
			return _parents;
		}
		
		/**
		 * @private
		 */
		public function set parents(value:ArrayCollection):void {
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
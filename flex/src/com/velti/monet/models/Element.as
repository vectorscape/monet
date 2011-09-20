package com.velti.monet.models 
{
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.models.elementData.ElementData;
	
	import flash.events.Event;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.collections.ArrayCollection;
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
	[Event(name="propertyChange", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	
	/**
	 * Represents one element or node in the
	 * plan graph.
	 * 
	 * @author Ian Serlin
	 */	
	[RemoteClass]
	public class Element extends DataObject implements IExternalizable
	{
		public static const PROPERTY_CHANGED:String = "propertyChange";
		
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
			if(_data) _data.removeEventListener(PROPERTY_CHANGED,data_propertyChange);
			_data = ElementData.getDataForType(v);
			_data.addEventListener(PROPERTY_CHANGED,data_propertyChange,false,0,true);
			dispatchEvent(new Event(PROPERTY_CHANGED));
		}internal var _type:ElementType = ElementType.NONE;
		
		private function data_propertyChange(event:Event):void {
			dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGED));
		} 
		/**
		 * The properties of the Element
		 */
		[Bindable(event="propertyChange")]
		public function get data():ElementData {
			return _data;
		} internal var _data:ElementData;
		
		/**
		 * The label to display that visually
		 * describes this element.
		 */
		[Bindable(event="propertyChange")]
		public function get label():String {
			return data.labelString;
		}
		public function set label( value:String ):void {
			if(!data) _data = ElementData.NO_ELEMENT_DATA;
			data.labelString = value;
			dispatchEvent(new Event(PROPERTY_CHANGED));
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
			if(!type) type = ElementType.NONE;
			this.type 		= type;
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

		public function writeExternal(output:IDataOutput):void {
			output.writeObject({
				data:data,
				descendents:descendents,
				elementID: elementID,
				isTemplate: isTemplate,
				label:label,
				type:type,
				parents:parents
			});
			
		}

		public function readExternal(input:IDataInput):void {
			var obj:Object = input.readObject();
			this.type = ElementType.getTypeByName(obj.type);
			this._data = obj.data;
			this.descendents = obj.descendants as ArrayCollection;
			this.parents = obj.parents as ArrayCollection;
			this.elementID = obj.elementID as String;
			this.isTemplate = obj.isTemplate as Boolean;
			this.label = obj.label as String;
		}
	}
}
package com.velti.monet.models 
{
	import com.velti.monet.events.ElementEvent;
	
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	/**
	 * @see com.velti.monet.events.ElementEvent#DESCENDENTS_CHANGED 
	 */	
	[Event(name="descendentsChanged", type="com.velti.monet.events.ElementEvent")] // NO PMD
	
	/**
	 * Represents one element or node in the
	 * plan graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Element extends EventDispatcher 
	{
		/**
		 * The label to display that visually
		 * describes this element.
		 */
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
		 * The label to display that visually
		 * describes this element.
		 */
		public function get label():String {
			return _label;
		}
		public function set label( value:String ):void {
			if( _label != value ){
				_label = value;
			}
		}
		/**
		 * @private 
		 */		
		protected var _label:String;
		
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
		public var status:ElementStatus = ElementStatus.INCOMPLETE;
		
		/**
		 * True if this element should be treated as a isTemplate element.
		 */		
		public var isTemplate:Boolean = false;
		
		/**
		 * Constructor 
		 */
		public function Element( status:ElementStatus = null ) {
			this.elementID 	= UIDUtil.createUID();
			if(status) this.status = status;
			var className:String = getQualifiedClassName(this);
			var typeName:Class = getDefinitionByName(className) as Class;
			//this call is required in order for it to be 
			//serializable and preserve the type of the class
			registerClassAlias(className, typeName);
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
		
		public function clone():Element {
			var returnVal:Element = null;
			returnVal = ObjectUtil.copy(this) as Element;
			//exact copy but change the uid
			returnVal.elementID = UIDUtil.createUID();
			//copy the status since it's based on a const object
			returnVal.status = this.status;
			return returnVal;
		}
		
		public function get className():String {
			return getQualifiedClassName(this);
		}
	}
}
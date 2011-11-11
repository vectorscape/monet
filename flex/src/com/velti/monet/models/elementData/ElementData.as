package com.velti.monet.models.elementData
{
	import com.velti.MetadataNames;
	import com.velti.monet.models.DataObject;
	
	import flash.events.Event;
	
	import mx.events.PropertyChangeEvent;
	
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.MetadataContainer;
	import org.as3commons.reflect.Type;
	
	/**
	 * Base class for an elements data. 
	 * @author Clint Modien
	 */	
	[RemoteClass]
	public class ElementData extends DataObject
	{	
		/**
		 * Use this in place of null. 
		 */		
		public static const NO_ELEMENT_DATA:ElementData = new ElementData();
		
		public static const ANY_PROP_CHANGE:String = "anyPropChange";
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ElementData() {
			super();
			this.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, anyPropChange,false,0,true);
		}
		
		/**
		 * Event handler for any prop change event
		 * 
		 */		
		protected function anyPropChange(e:Event):void {
			dispatchEvent(new Event(ANY_PROP_CHANGE));
		}
		
		/**
		 * Overriden in the base class.
		 * This method is called to show the text on the 
		 * on a node element. 
		 * 
		 */		
		public function get labelString():String {
			//override in base class
			return _labelString;
		} public function set labelString(v:String):void {
			//override in base class
			_labelString = v;
		}
		/**
		 * @private
		 */
		private var _labelString:String;
		
		/**
		 * Used to denote that all this elements 
		 * data is in a valid state. 
		 * 
		 */
		[Bindable(event="anyPropChange")]
		public function get isValid():Boolean {
			//override in base class
			return false;
		}
		
		/**
		 * Returns a list of properties (getters and vars) for this object
		 */
		[ArrayElementType("com.velti.monet.models.elementData.VeltiInspectableProperty")]
		public function get propertyList():Array {
			var returnVal:Array = [];
			var type:Type = Type.forInstance(this);
			var containers:Array = type.getMetadataContainers(MetadataNames.VELTI_INSPECTABLE);
			for each(var container:MetadataContainer in containers) {
				if(container is Field) {
					var field:Field = container as Field;
					returnVal.push(new VeltiInspectableProperty(field.name, getValueString(field))); // NO PMD
				}
			}
			return returnVal;
		}
		
		/**
		 * Returns a list of properties that can be duplicated for this object.
		 */
		[ArrayElementType("com.velti.monet.models.elementData.DuplicatableProperty")]
		public function get duplicatablePropertyList():Array {
			var returnVal:Array = [];
			var type:Type = Type.forInstance(this);
			var containers:Array = type.getMetadataContainers(MetadataNames.DUPLICATABLE);
			for each(var container:MetadataContainer in containers) {
				if(container is Field) {
					var field:Field = container as Field;
					returnVal.push(new DuplicatableProperty(field.name, getValueString(field))); // NO PMD
				}
			}
			return returnVal;
		}
		
		private function getValueString(field:Field):String {
			var returnVal:String;
			var propName:String = field.name;
			if(this[propName] == null) return "";
			if(typeof(this[propName]) == "object")
				if(this[propName] is Array)
					returnVal = (this[propName] as Array).join();
				else if(this[propName] is Date)
					returnVal = (this[propName] as Date).toDateString();
				else
					returnVal = this[propName].toString();
			else if(typeof(this[propName]) == "number" && isNaN(this[propName]))
				returnVal = "0";
			else
				returnVal  = this[propName];
			return returnVal;
		}
		
		public function copyValues( data:ElementData ):ElementData {
			var propsList:Array = this.duplicatablePropertyList;
			for each (var prop:DuplicatableProperty in propsList) {
				try {
					data[prop.name] = this[prop.name];
				} catch (err:ReferenceError) {
					if(err.message.indexOf("read-only") == -1)
						throw(err);
				}
			}
			return data;
		}
		
		public function duplicate():ElementData {
			throw new Error("you must override duplicate in your subclass of ElementData");
		}
	}
}
package com.velti.monet.models.elementData
{
	import flash.events.Event;
	
	import mx.events.PropertyChangeEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	/**
	 * The element data for a publisher 
	 * @author Clint Modien
	 * 
	 */	
	public class PublisherElementData extends ElementData
	{
		public static const NODE_CHANGED:String = "nodeChanged";
		
		/**
		 * @private 
		 */		
		internal var resMgr:IResourceManager = ResourceManager.getInstance();
		
		private var _node:XML;
		
		/**
		 * The name of the publisher or placement 
		 */
		[Bindable(event="propertyChange")][VeltiInspectable]
		public function get name():String {
			return node ? node.@label : "";
		}
		
		[Bindable]
		public function get node():XML {
			return _node;
		}
		public function set node(v:XML):void {
			_node = v;
			dispatchEvent(new Event(PropertyChangeEvent.PROPERTY_CHANGE));
		}
		
		/**
		 * @inheritDoc 
		 */
		[Bindable]
		override public function get labelString():String {
			return isValid ? name : resMgr.getString("UI","publisher");
		} override public function set labelString(v:String):void {
			; // NO PMD
		}
		
		/**
		 * @inheritDoc
		 * 
		 */
		[Bindable(event="propertyChange")]
		override public function get isValid():Boolean {
			return name != null && name != "";
		}
	}
}
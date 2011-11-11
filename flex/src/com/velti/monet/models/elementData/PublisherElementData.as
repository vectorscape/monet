package com.velti.monet.models.elementData
{
	import flash.events.Event;
	
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
		/**
		 * @private 
		 */		
		private var _node:XML;
		
		/**
		 * The name of the publisher or placement 
		 */
		[VeltiInspectable]
		[Bindable(event="nodeChange")]
		public function get name():String {
			return node ? node.@label : "";
		}
		
		[Bindable][Duplicatable]
		public function get node():XML {
			return _node;
		}
		public function set node(v:XML):void {
			_node = v;
			dispatchEvent(new Event(NODE_CHANGED));
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
		[Bindable(event="anyPropChange")]
		override public function get isValid():Boolean {
			return name != null && name != "";
		}
		
		override public function duplicate():ElementData {
			return copyValues( new PublisherElementData() );
		}
	}
}
package com.velti.monet.models.elementData
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	/**
	 * The element data for a publisher 
	 * @author Clint Modien
	 * 
	 */	
	public class PlacementElementData extends ElementData
	{
		/**
		 * @private 
		 */		
		internal var resMgr:IResourceManager = ResourceManager.getInstance();
		
		/**
		 * The name of the publisher or placement 
		 */
		[Bindable][VeltiInspectable]
		public var name:String = "";
		
		/**
		 * @inheritDoc 
		 */
		[Bindable]
		override public function get labelString():String {
			return isValid ? name : resMgr.getString("UI","placement");
		} override public function set labelString(v:String):void {
			this.name = v;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function get isValid():Boolean {
			return name != null && name != "";
		}
	}
}
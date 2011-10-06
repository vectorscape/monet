package com.velti.monet.models.elementData
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class AudienceElementData extends ElementData
	{
		internal var resMgr:IResourceManager = ResourceManager.getInstance();
			
		[Bindable][VeltiInspectable]
		public var genders:Array;
		
		[Bindable][VeltiInspectable]
		public var ages:Array;
		
		[Bindable]
		override public function get labelString():String {
			return isValid ? resMgr.getString("UI","audienceTarget") : resMgr.getString("UI","audience");
		} override public function set labelString(v:String):void {
			;
		}
		
		override public function get isValid():Boolean {
			return ages != null || genders != null;
		}
	}
}
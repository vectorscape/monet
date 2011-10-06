package com.velti.monet.models.elementData
{
	import com.velti.monet.models.AdvertisementType;

	public class AdvertisementElementData extends ElementData
	{
		[Bindable][VeltiInspectable]
		public var name:String;
		
		[Bindable][VeltiInspectable]
		public var type:AdvertisementType;
		
		[Bindable][VeltiInspectable]
		public var actionType:String;
		
		[Bindable][VeltiInspectable]
		public var actionText:String;
		
		[Bindable][VeltiInspectable]
		public var addText:String;
		
		override public function get isValid():Boolean {
			return name != null && name != ""
				&& type != null
				&& actionType != null && actionType != ""
				&& actionText != null && actionText != "";
		}
		
		[Bindable]
		override public function get labelString():String {
			return name;
		} override public function set labelString(v:String):void {
			name = v;
		}
	}
}
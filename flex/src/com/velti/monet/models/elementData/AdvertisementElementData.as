package com.velti.monet.models.elementData
{
	public class AdvertisementElementData extends ElementData
	{
		[Bindable]
		public var name:String;
		
		override public function get isValid():Boolean {
			return name != null;
		}
	}
}
package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ISerializable2;

	[RemoteClass]
	public class AdvertisementElementData extends ElementData implements ISerializable2
		
	{
		[Bindable]
		public var name:String;
		
		override public function get isValid():Boolean {
			return name != null;
		}
	}
}
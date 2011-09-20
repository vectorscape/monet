package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ISerializable2;

	[RemoteClass]
	public class InteractionElementData extends ElementData implements ISerializable2
	{
		[Bindable]
		public var siteName:String;
		
		override public function get isValid():Boolean {
			return siteName != null;
		}
	}
}
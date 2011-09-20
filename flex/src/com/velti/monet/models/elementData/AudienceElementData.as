package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ISerializable2;
	[RemoteClass]
	public class AudienceElementData extends ElementData implements ISerializable2
	{
		[Bindable][VeltiInspectable]
		public var genders:Array;
		
		[Bindable][VeltiInspectable]
		public var ages:Array;
		
		override public function get isValid():Boolean {
			return ages != null || genders != null;
		}
	}
}
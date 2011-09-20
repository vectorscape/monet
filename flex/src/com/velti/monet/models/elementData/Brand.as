package com.velti.monet.models.elementData
{
	import com.velti.monet.models.DataObject;
	import com.velti.monet.models.ISerializable2;

	[RemoteClass]
	public class Brand extends DataObject implements ISerializable2
	{
		public var name:String = "brand";
		
		override public function toString():String {
			return name;
		}
	}
}
package com.velti.monet.models.elementData
{
	import com.velti.monet.models.DataObject;

	public class Brand extends DataObject
	{
		public var name:String = "brand";
		
		override public function toString():String {
			return name;
		}
	}
}
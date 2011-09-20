package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ISerializable2;

	[RemoteClass]
	public class KeyElementData extends ElementData implements ISerializable2
	{
		public var complete:Boolean = false;
		
		override public function get isValid():Boolean {
			return complete;
		}
	}
}
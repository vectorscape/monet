package com.velti.monet.models.elementData
{
	public class KeyElementData extends ElementData
	{
		public var complete:Boolean = false;
		
		override public function get isValid():Boolean {
			return complete;
		}
	}
}
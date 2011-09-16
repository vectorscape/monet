package com.velti.monet.models.elementData
{
	public class AudienceElementData extends ElementData
	{
		[Bindable]
		public var demographics:Array;
		
		override public function get isValid():Boolean {
			return demographics != null;
		}
	}
}
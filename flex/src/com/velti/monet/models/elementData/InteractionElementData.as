package com.velti.monet.models.elementData
{
	public class InteractionElementData extends ElementData
	{
		[Bindable]
		public var siteName:String;
		
		override public function get isValid():Boolean {
			return siteName != null;
		}
	}
}
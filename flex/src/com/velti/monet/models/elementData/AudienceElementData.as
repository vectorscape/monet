package com.velti.monet.models.elementData
{
	public class AudienceElementData extends ElementData
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
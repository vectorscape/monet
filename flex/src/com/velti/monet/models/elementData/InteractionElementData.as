package com.velti.monet.models.elementData
{
	public class InteractionElementData extends ElementData
	{
		[Bindable][VeltiInspectable]
		public var builtFrom:String;
		
		[Bindable][VeltiInspectable]
		public var createdUsing:String;
		
		[Bindable][VeltiInspectable]
		public var siteName:String;
		
		[Bindable][VeltiInspectable]
		public var pageName:String;
		
		[Bindable][VeltiInspectable]
		public var totalVisitors:uint;
		
		[Bindable][VeltiInspectable]
		public var totalVisits:uint;
		
		override public function get isValid():Boolean {
			return siteName != null && siteName != ""
				&& builtFrom != null && builtFrom != ""
				&& createdUsing != null && createdUsing != ""
				&& pageName != null && pageName != ""
				&& totalVisitors != 0
				&& totalVisits != 0;
		}
	}
}
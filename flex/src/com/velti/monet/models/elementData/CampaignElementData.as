package com.velti.monet.models.elementData
{
	import flash.events.Event;

	[Event(name="propertyChange", type="flash.events.Event")]
	public class CampaignElementData extends ElementData
	{
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		[Bindable][VeltiInspectable]
		public function get name():String {
			return _name;
		} public function set name(v:String):void {
			_name = v;
			dispatchEvent(new Event(PROPERTY_CHANGE));
		}private var _name:String = "";
		
		[Bindable][VeltiInspectable]
		public var brand:Brand;
		[Bindable][VeltiInspectable]
		public var startDate:Date;
		[Bindable][VeltiInspectable]
		public var endDate:Date;
		[Bindable][VeltiInspectable]
		public var budget:Number;
		[Bindable][VeltiInspectable]
		public var description:String = "";
		
		[Bindable]
		override public function get labelString():String {
			return name;
		} override public function set labelString(v:String):void {
			name = v;
		}
		
		override public function get isValid():Boolean {
			return name && name.length >= 5;
		}
	}
}
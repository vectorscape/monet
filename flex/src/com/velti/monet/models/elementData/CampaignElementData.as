package com.velti.monet.models.elementData
{
	import flash.events.Event;

	[Event(name="nameChanged", type="flash.events.Event")]
	public class CampaignElementData extends ElementData
	{
		[Bindable]
		public function get name():String {
			return _name;
		} public function set name(v:String):void {
			_name = v;
			dispatchEvent(new Event("nameChanged"));
		}private var _name:String = "";
		
		[Bindable]
		public var brand:Brand;
		[Bindable]
		public var startDate:Date;
		[Bindable]
		public var endDate:Date;
		[Bindable]
		public var budget:Number;
		[Bindable]
		public var description:String = "";
		
		[Bindable(event="nameChanged")]
		override public function get labelString():String {
			return name;
		} override public function set labelString(v:String):void {
			name = v;
		}
	}
}
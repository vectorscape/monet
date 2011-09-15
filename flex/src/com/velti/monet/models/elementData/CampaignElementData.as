package com.velti.monet.models.elementData
{
	import flash.events.Event;

	[Event(name="dataChanged", type="flash.events.Event")]
	public class CampaignElementData extends ElementData
	{
		public static const DATA_CHANGED:String = "dataChanged";
		
		[Bindable]
		public function get name():String {
			return _name;
		} public function set name(v:String):void {
			_name = v;
			dispatchEvent(new Event(DATA_CHANGED));
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
		
		[Bindable(event=DATA_CHANGED)]
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
package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ISerializable2;
	
	import flash.events.Event;

	
	[Event(name="propertyChange", type="flash.events.Event")]
	[RemoteClass]
	public class CampaignElementData extends ElementData implements ISerializable2
	{
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		[Bindable][VeltiInspectable]
		public var name:String;
		
		[Bindable][VeltiInspectable]
		public var brand:String
		;
		[Bindable][VeltiInspectable]
		public var startDate:Date;
		[Bindable][VeltiInspectable]
		public var endDate:Date;
		[Bindable][VeltiInspectable]
		public var budget:uint = 0;
		[Bindable][VeltiInspectable]
		public var description:String = "";
		
		[Bindable]
		override public function get labelString():String {
			return name;
		} override public function set labelString(v:String):void {
			name = v;
		}
		
		override public function get isValid():Boolean {
			return name != null;
		}
	}
}
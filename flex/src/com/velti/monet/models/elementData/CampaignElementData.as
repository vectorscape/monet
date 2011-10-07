package com.velti.monet.models.elementData
{
	import flash.events.Event;
	
	/**
	 * Element data for a plan
	 * @author Clint Modien
	 * 
	 */	
	public class CampaignElementData extends ElementData
	{	
		/**
		 * The name of the plan 
		 */		
		[Bindable][VeltiInspectable]
		public var name:String;
		/**
		 * The brand of the plan (e.g. Ford, Starbucks) 
		 */		
		[Bindable][VeltiInspectable]
		public var brand:String
		/**
		 * The start date of the campaign 
		 */		
		[Bindable][VeltiInspectable]
		public var startDate:Date;
		/**
		 * The end date of the campaign 
		 */		
		[Bindable][VeltiInspectable]
		public var endDate:Date;
		/**
		 * The amount of budget allocated for the paln 
		 */		
		[Bindable][VeltiInspectable]
		public var budget:Number = 0;
		/**
		 * The description of the plan 
		 */		
		[Bindable][VeltiInspectable]
		public var description:String = "";
		/**
		 * @inheritDoc 
		 */		
		[Bindable]
		override public function get labelString():String {
			return name;
		} override public function set labelString(v:String):void {
			name = v;
		}
		/**
		 * @inheritDoc
		 */	
		override public function get isValid():Boolean {
			return name != null && name != ""
				&& brand != null && brand != ""
				&& startDate != null
				&& endDate != null
				&& !isNaN(budget) && budget != 0;
				
		}
	}
}
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
		[Bindable][VeltiInspectable][Duplicatable]
		public var name:String;
		/**
		 * The brand of the plan (e.g. Ford, Starbucks) 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var brand:String
		/**
		 * The start date of the campaign 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var startDate:Date;
		/**
		 * The end date of the campaign 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var endDate:Date;
		/**
		 * The amount of budget allocated for the paln 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var budget:Number = 0;
		/**
		 * The description of the plan 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
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
		
		override public function duplicate():ElementData {
			return copyValues( new CampaignElementData() );
		}
	}
}
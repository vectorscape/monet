package com.velti.monet.models.elementData
{
	public class CampaignElementData extends ElementData
	{
		public function CampaignElementData()
		{
		}
		
		public var name:String = "";
		public var brand:Brand;
		public var startDate:Date;
		public var endDate:Date;
		public var budget:Number;
		public var description:String = "";
	}
}
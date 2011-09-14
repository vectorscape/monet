package com.velti.monet.models
{
	public class Campaign extends Element
	{
		public function Campaign()
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
package com.velti.monet.models 
{
	import com.velti.monet.collections.IInteractionCollection;
	import com.velti.monet.collections.IContentCollection;
	import com.velti.monet.collections.IPlacementsCollection;
	import com.velti.monet.collections.IPublisherCollection;
	
	public class Campaign 
	{
		public var name:String = "";
		public var brand:Brand;
		public var startDate:Date;
		public var endDate:Date;
		public var budget:Number;
		public var description:String = "";
		
		public var audience:Audience;
		public var publishers:IPublisherCollection;
		public var placements:IPlacementsCollection;
		public var content:IContentCollection;
		public var interactions:IInteractionCollection;
	}
}
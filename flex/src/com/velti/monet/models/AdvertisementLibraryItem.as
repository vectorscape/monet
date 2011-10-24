package com.velti.monet.models
{
	public class AdvertisementLibraryItem
	{
		[Bindable]
		public var url:String;
		
		[Bindable]
		public var label:String;
		
		public static function create(url:String, label:String):AdvertisementLibraryItem {
			var returnVal:AdvertisementLibraryItem = new AdvertisementLibraryItem();
			returnVal.url = url;
			returnVal.label = label;
			return returnVal;
		}
	}
}
package com.velti.monet.models
{
	public class CreativeLibraryItem
	{
		[Bindable]
		public var url:String;
		
		[Bindable]
		public var label:String;
		
		public static function create(url:String, label:String):CreativeLibraryItem {
			var returnVal:CreativeLibraryItem = new CreativeLibraryItem();
			returnVal.url = url;
			returnVal.label = label;
			return returnVal;
		}
	}
}
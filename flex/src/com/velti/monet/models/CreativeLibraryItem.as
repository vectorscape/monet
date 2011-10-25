package com.velti.monet.models
{
	public class CreativeLibraryItem
	{
		public static const AD1:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/card-banner.jpg',"Ad 1");
		public static const AD2:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/starbucks_banner1.png',"Ad 2");
		public static const AD3:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/Starbucks-Holiday-BOGO.png',"Ad 3");
		public static const AD4:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/text-add.png',"Ad 4");
		
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
		
		public function toString():String {
			return label;
		}
	}
}
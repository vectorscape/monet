package com.velti.monet.models
{
	import mx.collections.ArrayCollection;

	public class CreativeLibraryItem
	{
		public static const AD1:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/card-banner.jpg',"Banner Ad 1");
		public static const AD2:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/starbucks_banner1.png',"Banner Ad 2");
		public static const AD3:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/Starbucks-Holiday-BOGO.png',"Banner Ad 3");
		public static const AD4:CreativeLibraryItem = CreativeLibraryItem.create('assets/ads/text-add.png',"Text Ad 1");
		
		public static const ads:ArrayCollection = new ArrayCollection([
			CreativeLibraryItem.AD1,
			CreativeLibraryItem.AD2,
			CreativeLibraryItem.AD3,
			CreativeLibraryItem.AD4,
		]);
		
		[Bindable]
		public var url:String;
		
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var numTimesUsedInPlan:uint = 0;
		
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
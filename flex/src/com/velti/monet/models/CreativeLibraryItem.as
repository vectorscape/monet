package com.velti.monet.models
{
	import assetsEmbedded.creativeLibrary.CreativeLibraryAssets;
	
	import mx.collections.ArrayCollection;

	public class CreativeLibraryItem
	{
		public static const AD1:CreativeLibraryItem = CreativeLibraryItem.create(CreativeLibraryAssets.Asset1,"Banner Ad 1");
		public static const AD2:CreativeLibraryItem = CreativeLibraryItem.create(CreativeLibraryAssets.Asset2,"Banner Ad 2");
		public static const AD3:CreativeLibraryItem = CreativeLibraryItem.create(CreativeLibraryAssets.Asset3,"Banner Ad 3");
		public static const AD4:CreativeLibraryItem = CreativeLibraryItem.create(CreativeLibraryAssets.Asset4,"Text Ad 1");
		
		public static const ads:ArrayCollection = new ArrayCollection([
			CreativeLibraryItem.AD1,
			CreativeLibraryItem.AD2,
			CreativeLibraryItem.AD3,
			CreativeLibraryItem.AD4,
		]);
		
		[Bindable]
		public var asset:Class;
		
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var numTimesUsedInPlan:uint = 0;
		
		public static function create(asset:Class, label:String):CreativeLibraryItem {
			var returnVal:CreativeLibraryItem = new CreativeLibraryItem();
			returnVal.asset = asset;
			returnVal.label = label;
			return returnVal;
		}
		
		public function toString():String {
			return label;
		}
	}
}
package com.velti.monet.models {
	import assetsEmbedded.advertisements.AdvertisementAssets;
	
	/**
	 * Class that defines the types of interactions supported by the plan.
	 * 
	 * @author Ian Serlin
	 */	
	public class AdvertisementType extends SubType {
		public static const GENERIC:AdvertisementType = new AdvertisementType( "Generic", AdvertisementAssets.GENERIC ); 
		public static const AUDIO:AdvertisementType = new AdvertisementType( "Audio", AdvertisementAssets.AUDIO ); 
		public static const VIDEO:AdvertisementType = new AdvertisementType( "Video", AdvertisementAssets.VIDEO ); 
		public static const BANNER:AdvertisementType = new AdvertisementType( "Banner", AdvertisementAssets.BANNER ); 
		public static const RICH_MEDIA:AdvertisementType = new AdvertisementType( "Rich Media", AdvertisementAssets.RICH_MEDIA ); 
		public static const TEXT:AdvertisementType = new AdvertisementType( "Text", AdvertisementAssets.TEXT ); 
		
		/**
		 * Constructor
		 *  
		 * @param label
		 * @param icon
		 */		
		public function AdvertisementType(label:String, icon:Class){
			super( label, icon );
		}
		/**
		 * @inheritDoc
		 */
		public function toString():String {
			return label || "";
		}
	}
}
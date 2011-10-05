package com.velti.monet.models {
	import assetsEmbedded.advertisements.AdvertisementAssets;
	
	/**
	 * Class that defines the types of interactions supported by the plan.
	 * 
	 * @author Ian Serlin
	 */	
	public class AdvertisementType {
		public static const AUDIO:AdvertisementType = new AdvertisementType( "Audio", AdvertisementAssets.INTERACTION_AUDIO ); 
		public static const VIDEO:AdvertisementType = new AdvertisementType( "Video", AdvertisementAssets.INTERACTION_VIDEO ); 
		public static const BANNER:AdvertisementType = new AdvertisementType( "Banner", AdvertisementAssets.INTERACTION_BANNER ); 
		public static const RICH_MEDIA:AdvertisementType = new AdvertisementType( "Rich Media", AdvertisementAssets.INTERACTION_RICH_MEDIA ); 
		public static const TEXT:AdvertisementType = new AdvertisementType( "Text", AdvertisementAssets.INTERACTION_TEXT ); 
		
		/**
		 * Name of this interaction type. 
		 */		
		public var label:String;
		
		/**
		 * Icon that visually represents this interaction type. 
		 */		
		public var icon:Class;
		
		/**
		 * Constructor
		 *  
		 * @param label
		 * @param icon
		 */		
		public function AdvertisementType(label:String, icon:Class){
			this.label = label;
			this.icon = icon;
		}
	}
}
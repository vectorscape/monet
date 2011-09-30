package com.velti.monet.models {
	
	/**
	 * Class that defines the types of interactions supported by the plan.
	 * 
	 * @author Ian Serlin
	 */	
	public class AdvertisementType {
		
		public static const AUDIO:AdvertisementType = new AdvertisementType( "Audio", Assets.INTERACTION_AUDIO ); 
		public static const VIDEO:AdvertisementType = new AdvertisementType( "Video", Assets.INTERACTION_VIDEO ); 
		public static const BANNER:AdvertisementType = new AdvertisementType( "Banner", Assets.INTERACTION_BANNER ); 
		public static const RICH_MEDIA:AdvertisementType = new AdvertisementType( "Rich Media", Assets.INTERACTION_RICH_MEDIA ); 
		public static const TEXT:AdvertisementType = new AdvertisementType( "Text", Assets.INTERACTION_TEXT ); 
		
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
package com.velti.monet.models {
	
	/**
	 * Class that defines the types of interactions supported by the plan.
	 * 
	 * @author Ian Serlin
	 */	
	public class InteractionType {
		
		public static const AUDIO:InteractionType = new InteractionType( "Audio", Assets.INTERACTION_AUDIO ); 
		public static const VIDEO:InteractionType = new InteractionType( "Video", Assets.INTERACTION_VIDEO ); 
		public static const BANNER:InteractionType = new InteractionType( "Banner", Assets.INTERACTION_BANNER ); 
		public static const RICH_MEDIA:InteractionType = new InteractionType( "Rich Media", Assets.INTERACTION_RICH_MEDIA ); 
		public static const TEXT:InteractionType = new InteractionType( "Text", Assets.INTERACTION_TEXT ); 
		
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
		public function InteractionType(label:String = "", icon:Class = null){
			this.label = label;
			this.icon = icon;
		}
	}
}
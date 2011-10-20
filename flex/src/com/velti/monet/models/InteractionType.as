package com.velti.monet.models {
	import assetsEmbedded.interactions.InteractionAssets;
	
	/**
	 * Class that defines the types of interactions supported by the plan.
	 * 
	 * @author Clint Modien
	 */	
	public class InteractionType extends SubType {
		
		public static const CUSTOM:InteractionType = new InteractionType( "Custom", InteractionAssets.CUSTOM ); 
		public static const MOBILE_SITE:InteractionType = new InteractionType( "Mobile site", InteractionAssets.MOBILE_SITE ); 
		public static const ON_PACK:InteractionType = new InteractionType( "On pack", InteractionAssets.ON_PACK ); 
		public static const SWEEP_STAKES:InteractionType = new InteractionType( "Sweepstakes", InteractionAssets.SWEEPSTAKES ); 
		public static const TEXT_TO_COUPON:InteractionType = new InteractionType( "Text to coupon", InteractionAssets.TEXT_TO_COUPON );
		public static const TEXT_TO_INFO:InteractionType = new InteractionType( "Text to info", InteractionAssets.TEXT_TO_INFO );
		public static const VOTE_AND_POLL:InteractionType = new InteractionType( "Vote and poll", InteractionAssets.VOTE_AND_POLL );
		
		
		/**
		 * Constructor
		 *  
		 * @param label
		 * @param icon
		 */		
		public function InteractionType(label:String, icon:Class){
			super( label, icon );
		}
	}
}
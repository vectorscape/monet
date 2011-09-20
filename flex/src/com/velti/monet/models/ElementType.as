package com.velti.monet.models 
{
	import flash.text.engine.BreakOpportunity;

	/**
	 * The type of node (e.g. Plan, Audience, Publisher)
	 *  
	 * @author Clint Modien
	 */
	[RemoteClass]
	public class ElementType extends DataObject 
	{
		/**
		 * Represent the global plan node type.
		 */
		public static const NONE:ElementType = new ElementType("none", NONE);
		/**
		 * Represent the global plan node type.
		 */
		public static const KEY:ElementType = new ElementType("key", NONE);
		
		/**
		 * Represent the global plan node type.
		 */
		public static const INTERACTION:ElementType = new ElementType("interaction", INTERACTION);
		/**
		 * Represent the global plan node type.
		 */
		public static const ADVERTISEMENT:ElementType = new ElementType("ad", INTERACTION);
		/**
		 * Represent the global plan node type.
		 */
		public static const PLACEMENT:ElementType = new ElementType("placement", ADVERTISEMENT);
		/**
		 * Represent the global plan node type.
		 */
		public static const PUBLISHER:ElementType = new ElementType("publisher", PLACEMENT);
		/**
		 * Represent the global plan node type.
		 */
		public static const AUDIENCE:ElementType = new ElementType("audience", PUBLISHER);
		/**
		 * Represent the global plan node type.
		 */
		public static const CAMPAIGN:ElementType = new ElementType("campaign", AUDIENCE);
		
		/**
		 * The order of element types in a normal campaign plan. 
		 */		
		public static const ELEMENT_ORDER:Array = [ CAMPAIGN, AUDIENCE, PUBLISHER, PLACEMENT, ADVERTISEMENT, INTERACTION ];
		
		public static function getTypeByName(name:String):ElementType {
			var returnType:ElementType;
			switch(name) {
				case CAMPAIGN.name :
					returnType = CAMPAIGN;
					break;
				case AUDIENCE.name :
					returnType = AUDIENCE;
					break;
				case INTERACTION.name :
					returnType = INTERACTION;
					break;
				case INTERACTION.name :
					returnType = PUBLISHER;
					break;
				case PLACEMENT.name :
					returnType = PLACEMENT;
					break;
				case ADVERTISEMENT.name :
					returnType = ADVERTISEMENT;
					break;
				case KEY.name :
					returnType = KEY;
					break;
				case NONE.name :
					returnType = NONE;
					break;
				default :
					returnType = null;
					break;
			}
			return returnType;
		}
		
		/**
		 * Represent the global plan node type.
		 */
		public var name:String;
		
		/**
		 * Represents the type of element that is allowed to be a direct
		 * child of this element type. 
		 */		
		public var descendentType:ElementType;
		
		/**
		 * Constructor
		 * @param name The name of the node (e.g.publisher, placement);
		 * 
		 */
		public function ElementType(name:String = null, descendentType:ElementType = null) {
			if(!name) name = "none";
			this.name 			= name;
			this.descendentType = descendentType;
		}
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function toString():String {
			return this.name;
		}
	}
}
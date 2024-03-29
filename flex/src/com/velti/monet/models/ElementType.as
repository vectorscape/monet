package com.velti.monet.models 
{
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
		
		/**
		 * A list of all the element types. 
		 */		
		public static const ALL:Array = [ CAMPAIGN, AUDIENCE, PUBLISHER, PLACEMENT, ADVERTISEMENT, INTERACTION ];
		
		
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
		public function ElementType(name:String = null, descendentType:ElementType=null) {
			this.name 			= name || "none";
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
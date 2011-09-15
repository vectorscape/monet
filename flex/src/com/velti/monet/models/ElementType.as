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
		public static const INTERACTION:ElementType = new ElementType("interaction", INTERACTION);
		/**
		 * Represent the global plan node type.
		 */
		public static const ADVERTISEMENT:ElementType = new ElementType("ad", INTERACTION);
		/**
		 * Represent the global plan node type.
		 */
		public static const PLACEMENT:ElementType = new ElementType("placement", AD);
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
<<<<<<< HEAD
		public function ElementType(name:String, descendentType:ElementType=null)
		{
			this.name 			= name;
			this.descendentType = descendentType;
=======
		public function ElementType(name:String = "")
		{
			super();
			this.name = name;
>>>>>>> added data obj cloning and amf serialization
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
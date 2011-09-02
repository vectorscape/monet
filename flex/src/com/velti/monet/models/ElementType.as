package com.velti.monet.models {
	/**
	 * The type of node (e.g. Plan, Audience, Publisher)
	 *  
	 * @author Clint Modien
	 */	
	public class ElementType {
		/**
		 * Represent the global plan node type.
		 */
		public static const CAMPAIGN:ElementType = new ElementType("campaign");
		/**
		 * Represent the global plan node type.
		 */
		public static const AUDIENCE:ElementType = new ElementType("audience");
		/**
		 * Represent the global plan node type.
		 */
		public static const PUBLISHER:ElementType = new ElementType("publisher");
		/**
		 * Represent the global plan node type.
		 */
		public static const PLACEMENT:ElementType = new ElementType("placement");
		/**
		 * Represent the global plan node type.
		 */
		public static const CONTENT:ElementType = new ElementType("content");
		/**
		 * Represent the global plan node type.
		 */
		public static const INTERACTION:ElementType = new ElementType("interaction");
		/**
		 * Represent the global plan node type.
		 */
		public var name:String;
		
		/**
		 * Constructor
		 * @param name The name of the node (e.g.publisher, placement);
		 * 
		 */		
		public function ElementType(name:String)
		{
			this.name = name;
		}
		/**
		 * @inheritDoc 
		 * 
		 */		
		public function toString():String {
			return this.name;
		}
	}
}
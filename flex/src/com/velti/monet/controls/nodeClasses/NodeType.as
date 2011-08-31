package com.velti.monet.controls.nodeClasses
{
	/**
	 * The type of node (e.g. Plan, Audience, Publisher) 
	 * @author Clint Modien
	 * 
	 */	
	public class NodeType
	{
		/**
		 * Represent the global plan node type.
		 */
		public static const PLAN:NodeType = new NodeType("plan");
		/**
		 * Represent the global plan node type.
		 */
		public static const AUDIENCE:NodeType = new NodeType("audience");
		/**
		 * Represent the global plan node type.
		 */
		public static const PUBLISHER:NodeType = new NodeType("publisher");
		/**
		 * Represent the global plan node type.
		 */
		public static const PLACEMENT:NodeType = new NodeType("placement");
		/**
		 * Represent the global plan node type.
		 */
		public static const CONTENT:NodeType = new NodeType("content");
		/**
		 * Represent the global plan node type.
		 */
		public static const INTERACTION:NodeType = new NodeType("interaction");
		/**
		 * Represent the global plan node type.
		 */
		public var name:String;

		/**
		 * Constructor
		 * @param name The name of the node (e.g.publisher, placement);
		 * 
		 */		
		public function NodeType(name:String)
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
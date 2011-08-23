package com.velti.monet.controls.nodeClasses
{
	/**
	 * The status enum for a node.
	 * @author Clint Modien
	 * 
	 */	
	public class NodeStatus
	{
		/**
		 * Marks the status of a node as complete.
		 */		
		public static const COMPLETE:NodeStatus = new NodeStatus("complete");
		/**
		 * Marks the status of a node as incomplete. 
		 */		
		public static const INCOMPLETE:NodeStatus = new NodeStatus("incomplete");
		/**
		 * The string value indicating status (e.g. complete) 
		 */		
		public var value:String;
		/**
		 * The color of the status. 
		 */		
		public var color:uint;
		/**
		 * Constructor
		 * @param value
		 * @param color
		 * 
		 */		
		public function NodeStatus(value:String, color:uint = 0x000000) {
			this.value = value;
			this.color = color;
		}
	}
}
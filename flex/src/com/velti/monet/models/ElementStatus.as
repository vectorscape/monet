package com.velti.monet.models
{
	/**
	 * The status enum for a node.
	 * @author Clint Modien
	 * 
	 */	
	public class ElementStatus
	{
		/**
		 * Marks the status of a node as complete.
		 */		
		public static const COMPLETE:ElementStatus = new ElementStatus("complete");
		/**
		 * Marks the status of a node as incomplete. 
		 */		
		public static const INCOMPLETE:ElementStatus = new ElementStatus("incomplete");
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
		public function ElementStatus(value:String, color:uint = 0x000000) {
			this.value = value;
			this.color = color;
		}
	}
}
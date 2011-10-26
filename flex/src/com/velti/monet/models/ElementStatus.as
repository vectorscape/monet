package com.velti.monet.models
{
	/**
	 * The status enum for a node.
	 * @author Clint Modien
	 * 
	 */
	[RemoteClass]
	public class ElementStatus extends DataObject
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
		 * Constructor
		 * @param value
		 * @param color
		 * 
		 */		
		public function ElementStatus(value:String = "incomplete") {
			this.value = value;
		}
	}
}
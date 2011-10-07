package com.velti.monet.models.elementData
{
	/**
	 * Element data to denote elements used in the key.
	 * @author Clint Modien
	 * 
	 */	
	public class KeyElementData extends ElementData
	{
		/**
		 * Whether or not the element should appear complete
		 */		
		public var complete:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function get isValid():Boolean {
			return complete;
		}
	}
}
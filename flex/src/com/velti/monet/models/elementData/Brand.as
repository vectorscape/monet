package com.velti.monet.models.elementData
{
	import com.velti.monet.models.DataObject;
	/**
	 * An object denoting a brand. (e.g. Ford, Starbucks)
	 * @author Clint Modien
	 * 
	 */	
	public class Brand extends DataObject
	{
		/**
		 * The name of the brand. 
		 */		
		public var name:String = "brand";
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function toString():String {
			return name;
		}
	}
}
package com.velti.monet.models.elementData
{
	/**
	 * The element data for a publisher 
	 * @author Clint Modien
	 * 
	 */	
	public class PublisherElementData extends ElementData
	{
		/**
		 * The name of the publisher or placement 
		 */
		[Bindable][VeltiInspectable]
		public var name:String = "";
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function get isValid():Boolean {
			return name != null && name != "";
		}
	}
}
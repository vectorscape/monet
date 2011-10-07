package com.velti.monet.models.elementData
{
	/**
	 * The element data for a publisher 
	 * @author clint
	 * 
	 */	
	public class PublisherElementData extends ElementData
	{
		/**
		 *  
		 */		
		[Bindable][VeltiInspectable]
		public var placements:XMLList;
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function get isValid():Boolean {
			return placements != null;
		}
	}
}
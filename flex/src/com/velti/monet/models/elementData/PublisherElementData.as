package com.velti.monet.models.elementData
{
	public class PublisherElementData extends ElementData
	{
		[Bindable]
		public var placements:XMLList;
		
		override public function get isValid():Boolean {
			return placements != null;
		}
	}
}
package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ISerializable2;

	[RemoteClass]
	public class PublisherElementData extends ElementData implements ISerializable2
	{
		[Bindable]
		public var placements:XMLList;
		
		override public function get isValid():Boolean {
			return placements != null;
		}
	}
}
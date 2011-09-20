package com.velti.monet.models
{
	import com.velti.monet.collections.IndexedCollection;
	
	[RemoteClass]
	public class SavedPlansModel extends IndexedCollection implements ISerializable2
	{
		public function SavedPlansModel(indexedProperty:String=null, source:Array=null) {
			super(indexedProperty, source);
		}
	}
}
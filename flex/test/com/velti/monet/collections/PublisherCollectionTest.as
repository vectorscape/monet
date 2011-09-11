package com.velti.monet.collections
{	
	import com.velti.monet.models.Publisher;

	public class PublisherCollectionTest 
	{		
		protected var itemClass:Class = Publisher;
		protected var collectionClass:Class = PublisherCollection;
		protected var propertyToFind:String = "id";
		
		[Test]
		public function flashBuilderTestFix():void{}
		
		include "CollectionTest.as"
	}
}
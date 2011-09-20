package com.velti.monet.collections
{
	import org.flexunit.asserts.assertTrue;

	public class IndexedCollectionTest
	{		
		protected var sut:IndexedCollection;
		
		[Before]
		public function setUp():void {
			sut = new IndexedCollection();
		}
		
		[After]
		public function tearDown():void {
		}
		
		[Test]
		public function defaultTest():void {
			assertTrue(true);
		}
		
		private var cloneTestType:Class = IndexedCollection;
		
		include "../models/CloneTest.as"
	}
}
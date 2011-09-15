package com.velti.monet.models
{
	import org.flexunit.asserts.assertTrue;

	public class DataObjectTest
	{	
		private var sut:DataObject;
		
		[Before]
		public function setUp():void {
			sut = new DataObject();
		}
		
		[After]
		public function tearDown():void {
			
		}
		
		[Test]
		public function defaultTest():void {assertTrue(true)}
		
		private var cloneTestType:Class = DataObject;
		
		include "CloneTest.as"
	}
}
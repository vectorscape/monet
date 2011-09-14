package com.velti.monet.models
{
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.object.equalTo;

	/**
	 * Tests the Plan class.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanTest
	{
		protected var sut:Plan;
		
		[Before]
		public function setup():void {
			sut = new Plan();
		}
		
		[After]
		public function tearDown():void
		{
			sut = null;
		}
		
		[Test]
		public function testThat_nameIsString():void {
			assertTrue(sut.name is String);
		}
		
		[Test]
		public function testThat_canIterateOverProperties():void {
			//assertThat(sut.propertyList, hasItems(equalTo("name"),equalTo("brand")))
		}
	}
}
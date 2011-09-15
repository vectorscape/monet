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
		public function defaultTest():void{assertTrue(true)};
		
		private var cloneTestType:Class = Plan;
		
		include "CloneTest.as"
	}
}
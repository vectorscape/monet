package com.velti.monet.models
{
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	/**
	 * Tests the Campaign class.
	 * 
	 * @author Ian Serlin
	 */	
	public class CampaignTest
	{
		protected var sut:Campaign;
		
		[Before]
		public function setup():void {
			sut = new Campaign();
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
	}
}
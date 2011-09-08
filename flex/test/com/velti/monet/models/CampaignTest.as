package com.velti.monet.models
{
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class CampaignTest
	{
		protected var sut:Campaign;
		
		[Before]
		public function setup():void {
			sut = new Campaign();
		}
		
		[Test]
		public function testThat_nameIsString():void {
			assertTrue(sut.name is String);
		}
	}
}
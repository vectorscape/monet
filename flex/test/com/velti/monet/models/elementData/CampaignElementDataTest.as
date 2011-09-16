package com.velti.monet.models.elementData
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.object.equalTo;

	public class CampaignElementDataTest
	{		
		public var sut:CampaignElementData;
		
		[Before]
		public function setUp():void {
			sut = new CampaignElementData();
		}
		
		[After]
		public function tearDown():void {
			sut = null;
		}
		
		[Test]
		public function testThat_hasSuperClassProps():void {
			assertThat(sut.propertyList, hasItems(equalTo("isValid")));
		}
		
		[Test]
		public function testThat_hasOwnClassProps():void {
			assertThat(sut.propertyList, hasItems(equalTo("brand"),equalTo("startDate")));
		}
	}
}
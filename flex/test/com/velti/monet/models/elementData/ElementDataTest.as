package com.velti.monet.models.elementData
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.object.equalTo;

	public class ElementDataTest
	{
		protected var sut:ElementData;
		
		[Before]
		public function setUp():void {
			sut = new ElementData();
		}
		
		[After]
		public function tearDown():void {
			sut = null;
		}
		
		[Test]
		public function testThat_canIterateOverProperties():void {
			//assertThat(sut.propertyList, hasItems(equalTo("isValid")))
		}
	}
}
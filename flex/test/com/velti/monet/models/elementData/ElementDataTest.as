package com.velti.monet.models.elementData
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
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
		
		[Test]
		public function testThat_copyValues_copiesValues():void {
			sut = new AdvertisementElementData();
			(sut as AdvertisementElementData).actionType = "testactiontype";
			var dupe:AdvertisementElementData = new AdvertisementElementData();
			sut.copyValues( dupe );
			assertEquals( (sut as AdvertisementElementData).actionType, dupe.actionType );
			
			sut = new PublisherElementData();
			var node:XML = <data label='testlabel'/>;
			(sut as PublisherElementData).node = node;
			var dupe2:PublisherElementData = new PublisherElementData();
			sut.copyValues( dupe2 );
			assertEquals( (sut as PublisherElementData).name, dupe2.name );
		}
		
		[Test]
		public function testThat_duplicate_AdvertisementElementData_createsNew_advertisementElementData():void {
			sut = new AdvertisementElementData();
			var dupe:AdvertisementElementData = sut.duplicate() as AdvertisementElementData;
			assertThat( dupe, isA( AdvertisementElementData ) );
		}
		
		[Test]
		public function testThat_duplicate_AudienceElementData_createsNew_audienceElementData():void {
			sut = new AudienceElementData();
			var dupe:AudienceElementData = sut.duplicate() as AudienceElementData;
			assertThat( dupe, isA( AudienceElementData ) );
		}
		
		[Test]
		public function testThat_duplicate_CampaignElementData_createsNew_campaignElementData():void {
			sut = new CampaignElementData();
			var dupe:CampaignElementData = sut.duplicate() as CampaignElementData;
			assertThat( dupe, isA( CampaignElementData ) );
		}
		
		[Test]
		public function testThat_duplicate_interactionElementData_createsNew_interactionElementData():void {
			sut = new InteractionElementData();
			var dupe:InteractionElementData = sut.duplicate() as InteractionElementData;
			assertThat( dupe, isA( InteractionElementData ) );
		}
		
		[Test]
		public function testThat_duplicate_keyElementData_createsNew_keyElementData():void {
			sut = new KeyElementData();
			var dupe:KeyElementData = sut.duplicate() as KeyElementData;
			assertThat( dupe, isA( KeyElementData ) );
		}
		
		[Test]
		public function testThat_duplicate_placementElementData_createsNew_placementElementData():void {
			sut = new PlacementElementData();
			var dupe:PlacementElementData = sut.duplicate() as PlacementElementData;
			assertThat( dupe, isA( PlacementElementData ) );
		}
		
		[Test]
		public function testThat_duplicate_publisherElementData_createsNew_publisherElementData():void {
			sut = new PublisherElementData();
			var dupe:PublisherElementData = sut.duplicate() as PublisherElementData;
			assertThat( dupe, isA( PublisherElementData ) );
		}
	}
}
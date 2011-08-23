package com.velti.monet.models
{
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.nullValue;

	public class CampaignTest
	{
		
		private var _sut:Campaign;
		
		[Before]
		public function setUp():void
		{
			_sut = new Campaign();
		}
		
		[After]
		public function tearDown():void
		{
			_sut = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testThat_newCampaign_hasFiveElements():void {
			assertEquals( _sut.elements.length, 5 );
		}
		
		[Test]
		public function testThat_newCampaign_containsOnlyElements():void {
			for each( var element:Object in _sut.elements ){
				assertThat( element, isA( Element ) );
			}
		}
		
		[Test]
		public function testThat_newCampaign_hasAn_audienceElement():void {
			assertTrue( campaignHasElementType( _sut.elements, ElementTypes.AUDIENCE ) );
		}
		
		[Test]
		public function testThat_newCampaign_hasA_publisherElement():void {
			assertTrue( campaignHasElementType( _sut.elements, ElementTypes.PUBLISHER ) );
		}
		
		[Test]
		public function testThat_newCampaign_hasA_placementElement():void {
			assertTrue( campaignHasElementType( _sut.elements, ElementTypes.PLACEMENT ) );
		}
		
		[Test]
		public function testThat_newCampaign_hasA_contentElement():void {
			assertTrue( campaignHasElementType( _sut.elements, ElementTypes.CONTENT ) );
		}
		
		[Test]
		public function testThat_newCampaign_hasA_resultsElement():void {
			assertTrue( campaignHasElementType( _sut.elements, ElementTypes.RESULTS ) );
		}

		[Test]
		public function testThat_createDefaults():void {
			_sut.elements = new ArrayCollection();
			_sut.createDefaults();
			assertEquals( _sut.elements.length, 5 );
		}
		
		/**
		 * Searches through a set of elements for a particular
		 * type and returns true if that type is found.
		 * 
		 * @param elements Set of elements to search through
		 * @param type The type of element to look for
		 * @return true if the type is found, false otherwise
		 */		
		protected function campaignHasElementType( elements:IList, type:String ):Boolean {
			for each( var element:Object in elements ){
				if( element.type == type ){
					return true;
				}
			}
			return false;
		}
	}
}
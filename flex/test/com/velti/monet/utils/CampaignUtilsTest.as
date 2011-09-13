package com.velti.monet.utils {
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.throws;
	
	/**
	 * Tests the CampaignUtils class.
	 * 
	 * @author Ian Serlin
	 */	
	public class CampaignUtilsTest {
		
		[Before]
		public function setup():void {
		}
		
		[After]
		public function tearDown():void {
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsTrue_forAudienceElements():void {
			var testElement:Element = new Element( ElementType.AUDIENCE );
			assertTrue( CampaignUtils.filterAudiencesOnly( testElement ) );
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNonAudienceElements():void {
			for each( var type:ElementType in [ ElementType.CAMPAIGN, ElementType.INTERACTION, ElementType.AD, ElementType.PLACEMENT, ElementType.PUBLISHER ] ){
				var testElement:Element = new Element( type );
				assertFalse( CampaignUtils.filterAudiencesOnly( testElement ) );				
			}
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNull():void {
			assertFalse( CampaignUtils.filterAudiencesOnly( null ) );				
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNonElementObjects():void {
			assertFalse( CampaignUtils.filterAudiencesOnly( {} ) );
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsTrue_forCampaignElements():void {
			var testElement:Element = new Element( ElementType.CAMPAIGN );
			assertTrue( CampaignUtils.filterCampaignsOnly( testElement ) );
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsFalse_forNonAudienceElements():void {
			for each( var type:ElementType in [ ElementType.AUDIENCE, ElementType.INTERACTION, ElementType.AD, ElementType.PLACEMENT, ElementType.PUBLISHER ] ){
				var testElement:Element = new Element( type );
				assertFalse( CampaignUtils.filterCampaignsOnly( testElement ) );				
			}
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsFalse_forNull():void {
			assertFalse( CampaignUtils.filterCampaignsOnly( null ) );				
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsFalse_forNonElementObjects():void {
			assertFalse( CampaignUtils.filterCampaignsOnly( {} ) );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofEmptyBranch_returnsZero():void {
			assertEquals( 0, CampaignUtils.measureWidthOfBranch( [], new Campaign() ) );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofNull_returnsZero():void {
			assertEquals( 0, CampaignUtils.measureWidthOfBranch( null, new Campaign() ) );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofNullCampaign_throwsAnError():void {
			var error:Error;
			try{
				CampaignUtils.measureWidthOfBranch( null, null );
			}catch( e:Error ){
				error = e;
			}
			assertNotNull( error );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofCampaign_withWidth5_atTheEnd_returns5():void {
			_testThat_campaignWithDesign_hasProperMeasuredWidth( [ 1, 2, 3, 4, 5 ] );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofCampaign_withWidth5_inTheMiddle_returns5():void {
			_testThat_campaignWithDesign_hasProperMeasuredWidth( [ 1, 2, 5, 4, 3 ] );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofCampaign_withWidth5_inTheBeginning_returns5():void {
			_testThat_campaignWithDesign_hasProperMeasuredWidth( [ 5, 2, 1, 4, 3 ] );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofCampaign_withWidth5_everywhere_returns5():void {
			_testThat_campaignWithDesign_hasProperMeasuredWidth( [ 5, 5, 5, 5, 5 ] );
		}
	
		/**
		 * Configures a new campaign with the given elements per level and calls
		 * measure width of branch on the campaign to check the max width is
		 * calculated properly.
		 */		
		public function _testThat_campaignWithDesign_hasProperMeasuredWidth( elementsPerLevel:Array ):void {
			var expected:int = 0;
			for each( var spec:int in elementsPerLevel ){
				if( spec > expected ){
					expected = spec;
				}
			}
			var campaign:Campaign = new Campaign();
			campaign = configureCampaign( campaign, elementsPerLevel );
			var audienceElementIDs:Array = [];
			for each( var audienceElement:Element in campaign.audiences ){
				audienceElementIDs.push( audienceElement.elementID );
			}
			assertEquals( expected, CampaignUtils.measureWidthOfBranch( audienceElementIDs, campaign ) );
		}
		
		/**
		 * Configures the given campaign with the given numbers of the specified
		 * types of elements.
		 * 
		 * @param campaign
		 * @return 
		 */		
		protected function configureCampaign( campaign:Campaign, elementsPerLevel:Array ):Campaign {
			var element:Element;
			var previousElement:Element;
			for( var i:int = 0; i < elementsPerLevel.length; i++ ){
				var desiredNumberOfElements:int = elementsPerLevel[ i ] as int;
				for( var j:int = 0; j < desiredNumberOfElements; j++ ){
					element = new Element( i == 0 ? ElementType.AUDIENCE : ElementType.PUBLISHER ); // type doesn't matter here
					campaign.addItem( element );
					if( previousElement ){
						previousElement.descendents.addItem( element.elementID );
					}
				}
				previousElement = element;
			}
			return campaign;
		}
		
	}
}
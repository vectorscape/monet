package com.velti.monet.utils {
	import com.velti.monet.models.Audience;
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Plan;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	
	/**
	 * Tests the PlanUtils class.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanUtilsTest {
		
		[Before]
		public function setup():void {
		}
		
		[After]
		public function tearDown():void {
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsTrue_forAudienceElements():void {
			assertTrue( PlanUtils.filterAudiencesOnly( new Audience() ) );
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNonAudienceElements():void {
			assertFalse( PlanUtils.filterAudiencesOnly( new Campaign() ) );				
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNull():void {
			assertFalse( PlanUtils.filterAudiencesOnly( null ) );				
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsTrue_forCampaignElements():void {
			assertTrue( PlanUtils.filterCampaignsOnly( new Campaign() ) );
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsFalse_forNonCampaignElements():void {
			assertFalse( PlanUtils.filterCampaignsOnly( new Audience() ) );
		}
		
		[Test]
		public function testThat_filterCampaignsOnly_returnsFalse_forNull():void {
			assertFalse( PlanUtils.filterCampaignsOnly( null ) );				
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofEmptyBranch_returnsZero():void {
			assertEquals( 0, PlanUtils.measureWidthOfBranch( [], new Plan() ) );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofNull_returnsZero():void {
			assertEquals( 0, PlanUtils.measureWidthOfBranch( null, new Plan() ) );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofNullPlan_throwsAnError():void {
			var error:Error;
			try{
				PlanUtils.measureWidthOfBranch( null, null );
			}catch( e:Error ){
				error = e;
			}
			assertNotNull( error );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofPlan_withWidth5_atTheEnd_returns5():void {
			_testThat_planWithDesign_hasProperMeasuredWidth( [ 1, 2, 3, 4, 5 ] );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofPlan_withWidth5_inTheMiddle_returns5():void {
			_testThat_planWithDesign_hasProperMeasuredWidth( [ 1, 2, 5, 4, 3 ] );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofPlan_withWidth5_inTheBeginning_returns5():void {
			_testThat_planWithDesign_hasProperMeasuredWidth( [ 5, 2, 1, 4, 3 ] );
		}
		
		[Test]
		public function testThat_measureWidthOfBranch_ofPlan_withWidth5_everywhere_returns5():void {
			_testThat_planWithDesign_hasProperMeasuredWidth( [ 5, 5, 5, 5, 5 ] );
		}
	
		/**
		 * Configures a new plan with the given elements per level and calls
		 * measure width of branch on the plan to check the max width is
		 * calculated properly.
		 */		
		public function _testThat_planWithDesign_hasProperMeasuredWidth( elementsPerLevel:Array ):void {
			var expected:int = 0;
			for each( var spec:int in elementsPerLevel ){
				if( spec > expected ){
					expected = spec;
				}
			}
			var plan:Plan = new Plan();
			plan = configurePlan( plan, elementsPerLevel );
			var campaignElementIDs:Array = [];
			for each( var campaignElement:Element in plan.campaigns ){
				campaignElementIDs.push( campaignElement.elementID );
			}
			assertEquals( expected, PlanUtils.measureWidthOfBranch( campaignElementIDs, plan ) );
		}
		
		/**
		 * Configures the given plan with the given numbers of the specified
		 * types of elements.
		 * 
		 * @param plan
		 * @return 
		 */		
		protected function configurePlan( plan:Plan, elementsPerLevel:Array ):Plan {
			var element:Element;
			var previousElement:Element;
			for( var i:int = 0; i < elementsPerLevel.length; i++ ){
				var desiredNumberOfElements:int = elementsPerLevel[ i ] as int;
				for( var j:int = 0; j < desiredNumberOfElements; j++ ){
					element = i == 0 ? new Campaign() : new Audience(); // type doesn't matter here
					plan.addItem( element );
					if( previousElement ){
						previousElement.descendents.addItem( element.elementID );
					}
				}
				previousElement = element;
			}
			return plan;
		}
		
	}
}
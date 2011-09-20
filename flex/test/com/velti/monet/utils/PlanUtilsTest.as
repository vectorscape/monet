package com.velti.monet.utils {
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.Plan;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.throws;
	
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
			var testElement:Element = new Element( ElementType.AUDIENCE );
			assertTrue( PlanUtils.filterAudiencesOnly( testElement ) );
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNonAudienceElements():void {
			for each( var type:ElementType in [ ElementType.CAMPAIGN, ElementType.INTERACTION, ElementType.ADVERTISEMENT, ElementType.PLACEMENT, ElementType.PUBLISHER ] ){
				var testElement:Element = new Element( type );
				assertFalse( PlanUtils.filterAudiencesOnly( testElement ) );				
			}
		}
		
		[Test]
		public function testThat_filterAudiencesOnly_returnsFalse_forNull():void {
			assertFalse( PlanUtils.filterAudiencesOnly( null ) );				
		}
		
		[Test]
		public function testThat_filterPlansOnly_returnsTrue_forPlanElements():void {
			var testElement:Element = new Element( ElementType.CAMPAIGN );
			assertTrue( PlanUtils.filterCampaignsOnly( testElement ) );
		}
		
		[Test]
		public function testThat_filterPlansOnly_returnsFalse_forNonAudienceElements():void {
			for each( var type:ElementType in [ ElementType.AUDIENCE, ElementType.INTERACTION, ElementType.ADVERTISEMENT, ElementType.PLACEMENT, ElementType.PUBLISHER ] ){
				var testElement:Element = new Element( type );
				assertFalse( PlanUtils.filterCampaignsOnly( testElement ) );				
			}
		}
		
		[Test]
		public function testThat_filterPlansOnly_returnsFalse_forNull():void {
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
			var audienceElementIDs:Array = [];
			for each( var audienceElement:Element in plan.audiences ){
				audienceElementIDs.push( audienceElement.elementID );
			}
			assertEquals( expected, PlanUtils.measureWidthOfBranch( audienceElementIDs, plan ) );
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
					element = new Element( i == 0 ? ElementType.AUDIENCE : ElementType.PUBLISHER ); // type doesn't matter here
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
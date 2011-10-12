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
			assertTrue( PlanUtils.filterPlansOnly( testElement ) );
		}
		
		[Test]
		public function testThat_filterPlansOnly_returnsFalse_forNonAudienceElements():void {
			for each( var type:ElementType in [ ElementType.AUDIENCE, ElementType.INTERACTION, ElementType.ADVERTISEMENT, ElementType.PLACEMENT, ElementType.PUBLISHER ] ){
				var testElement:Element = new Element( type );
				assertFalse( PlanUtils.filterPlansOnly( testElement ) );				
			}
		}
		
		[Test]
		public function testThat_filterPlansOnly_returnsFalse_forNull():void {
			assertFalse( PlanUtils.filterPlansOnly( null ) );				
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
						previousElement.descendents.add( element );
					}
				}
				previousElement = element;
			}
			return plan;
		}
		
	}
}
//		add tests for adding and removing an element
//		then actually make the functions
//		then make the SWIZ events for it
//		then write the controller functions to add them
//		then dispatch the events from the plan view
//		then dispatch the events from the plan library

package com.velti.monet.controllers {
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementTest;
	import com.velti.monet.models.ElementType;
	
	import mx.collections.IList;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	
	/**
	 * Tests the PlanController
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanControllerTest {
		
		/**
		 * The suite under test (sut) 
		 */		
		public var sut:PlanController;
		
		/**
		 * Plan the controller is manipulating. 
		 */		
		protected var plan:Plan;
		
		/**
		 * setup method 
		 */		
		[Before]
		public function setUp():void {
			sut = new PlanController();
			plan = new Plan();
			sut.plan = plan;
			sut.createPlanDefaults();
		}
		/**
		 * tearDown method 
		 */		
		[After]
		public function tearDown():void {
			sut = null;
			plan = null;
		}

		[Test]
		public function testThat_createPlanDefaults_containsOnlyElements():void {
			for each( var element:Object in sut.plan ){
				assertThat( element, isA( Element ) );
			}
		}

		[Test]
		public function testThat_createPlanDefaults_createsAPublisher_asAChildOfAudience():void {
			_testThat_childHasAppropriateParent( ElementType.PUBLISHER, ElementType.AUDIENCE );
		}

		[Test]
		public function testThat_createPlanDefaults_createsAPlacement_asAChildOfPublisher():void {
			_testThat_childHasAppropriateParent( ElementType.PLACEMENT, ElementType.PUBLISHER );
		}

		[Test]
		public function testThat_createPlanDefaults_createsAnAd_asAChildOfPlacement():void {
			_testThat_childHasAppropriateParent( ElementType.AD, ElementType.PLACEMENT );
		}

		[Test]
		public function testThat_createPlanDefaults_createsAnInteraction_asAChildOfAd():void {
			_testThat_childHasAppropriateParent( ElementType.INTERACTION, ElementType.AD );
		}
		
		[Test]
		public function testThat_createPlanDefaults_hasAn_audienceElement():void {
			assertTrue( planHasElementType( sut.plan, ElementType.AUDIENCE ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_hasA_publisherElement():void {
			assertTrue( planHasElementType( sut.plan, ElementType.PUBLISHER ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_hasA_placementElement():void {
			assertTrue( planHasElementType( sut.plan, ElementType.PLACEMENT ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_hasA_contentElement():void {
			assertTrue( planHasElementType( sut.plan, ElementType.AD ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_hasA_interactionElement():void {
			assertTrue( planHasElementType( sut.plan, ElementType.INTERACTION ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_creates5Elements():void {
			assertEquals( 6, sut.plan.length );
		}
		
		[Test]
		public function testThat_newPlan_clearsAllElements_and_addsDefaults():void {
			var oldElement:Element = sut.plan.getItemAt( 0 ) as Element;
			sut.newPlan();
			assertThat( sut.plan.length, equalTo( 6 ) );
			assertFalse( sut.plan.contains( oldElement ) ); 
		}
		
		[Test]
		public function testThat_removeElement_removesFromThePlan():void {
			sut.removeElement( plan.getItemAt( 0 ) as Element );
			assertThat( sut.plan.length, equalTo( 5 ) );
		}
		
		[Test]
		public function testThat_addElement_addsToThePlan():void {
			var element:Element = new Element( ElementType.AD );
			sut.addElement( element );
			assertTrue( sut.plan.contains( element ) );
			assertThat( sut.plan.length, equalTo( 7 ) );
		}

		[Test]
		public function testThat_addElement_addsPlans_atTheRightLevel():void {
			var newElement:Element = new Element( ElementType.CAMPAIGN );
			sut.addElement( newElement );
			for each( var existingElement:Element in sut.plan ){
				assertFalse( existingElement.descendents.contains( newElement.elementID ) );
			}
		}
		
		[Test]
		public function testThat_addElement_addsAudiences_atTheRightLevel():void {
			_testThat_elementAddsAtRightLevel( ElementType.AUDIENCE, ElementType.CAMPAIGN );
		}
		
		[Test]
		public function testThat_addElement_addsPublishers_atTheRightLevel():void {
			_testThat_elementAddsAtRightLevel( ElementType.PUBLISHER, ElementType.AUDIENCE );
		}
		
		[Test]
		public function testThat_addElement_addsPlacements_atTheRightLevel():void {
			_testThat_elementAddsAtRightLevel( ElementType.PLACEMENT, ElementType.PUBLISHER );
		}
		
		[Test]
		public function testThat_addElement_addsAds_atTheRightLevel():void {
			_testThat_elementAddsAtRightLevel( ElementType.AD, ElementType.PLACEMENT );
		}
		
		[Test]
		public function testThat_addElement_addsInteractions_atTheRightLevel():void {
			_testThat_elementAddsAtRightLevel( ElementType.INTERACTION, ElementType.AD );
		}
		
		/**
		 * Tests that given a new element of type <code>newType</code>,
		 * after adding it to the plan, the element has one parent 
		 * element of type <code>parentType</code>.
		 * 
		 * @param newType
		 * @param parentType
		 */		
		protected function _testThat_elementAddsAtRightLevel( newType:ElementType, parentType:ElementType ):void {
			var newElement:Element = new Element( newType );
			var parentElement:Element;
			var count:int = 0;
			for each( var existingElement:Element in sut.plan ){
				if( existingElement.type == parentType ){
					parentElement = existingElement;
					count++;
				}
			}
			sut.addElement( newElement );
			assertTrue( parentElement.descendents.contains( newElement.elementID ) );
			assertTrue( count == 1 );
		}
		
		
		/**
		 * Searches through a set of elements for a particular
		 * type and returns true if that type is found.
		 * 
		 * @param elements Set of elements to search through
		 * @param type The type of element to look for
		 * @return true if the type is found, false otherwise
		 */		
		protected function planHasElementType( elements:IList, type:ElementType ):Boolean {
			for each( var element:Object in elements ){
				if( element.type == type ){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Searches the sut's plan for a child of the given type,
		 * returns the first occurrence found.
		 * 
		 * @param type the type of the element you are looking for.
		 * @return the desired element, if any
		 */		
		protected function getElementOfType( type:ElementType ):Element {
			var desiredElement:Element;
			for each( var element:Element in sut.plan ){
				if( element.type == type ){
					desiredElement = element;
					break;
				}
			}
			return desiredElement;
		}
		
		/**
		 * Tests that the parent of parentType has the child of childType
		 * in its descendents.
		 * 
		 * @param childType
		 * @param parentType
		 */		
		protected function _testThat_childHasAppropriateParent( childType:ElementType, parentType:ElementType ):void {
			var childElement:Element = getElementOfType( childType );
			var parentElement:Element = getElementOfType( parentType );
			assertTrue( parentElement.descendents.contains( childElement.elementID ) );
		}
	}
}
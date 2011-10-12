//		add tests for adding and removing an element
//		then actually make the functions
//		then make the SWIZ events for it
//		then write the controller functions to add them
//		then dispatch the events from the plan view
//		then dispatch the events from the plan library

package com.velti.monet.controllers {
	import com.velti.monet.events.ElementRendererEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementTest;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.Plan;
	import com.velti.monet.utils.ElementUtils;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import flexunit.utils.Collection;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
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
			_testThat_childHasAppropriateParent( ElementType.ADVERTISEMENT, ElementType.PLACEMENT );
		}

		[Test]
		public function testThat_createPlanDefaults_createsAnInteraction_asAChildOfAd():void {
			_testThat_childHasAppropriateParent( ElementType.INTERACTION, ElementType.ADVERTISEMENT );
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
			assertTrue( planHasElementType( sut.plan, ElementType.ADVERTISEMENT ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_hasA_interactionElement():void {
			assertTrue( planHasElementType( sut.plan, ElementType.INTERACTION ) );
		}
		
		[Test]
		public function testThat_createPlanDefaults_creates6Elements():void {
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
			var elementToBeRemoved:Element = plan.getItemAt( 0 ) as Element;
			sut.removeElement( elementToBeRemoved );
			assertFalse( sut.plan.contains( elementToBeRemoved ) );
		}
		
		[Test]
		public function testThat_removeElement_removesAllReferencesToTheElement():void {
			var elementToBeRemoved:Element = plan.getItemAt( 0 ) as Element; 
			var element:Element;
			for( var i:int = 0; i < 5; i++ ){
				element = new Element( ElementType.ADVERTISEMENT );
				plan.addItem( element );
				if( i % 2 == 0 ){
					ElementUtils.linkElements( elementToBeRemoved, element ); 
				}else{
					ElementUtils.linkElements( element, elementToBeRemoved );
				}
			}
			sut.removeElement( elementToBeRemoved  );
			for each( element in plan ){
//				assertFalse( element.descendents.containsElement( elementToBeRemoved ) );
				assertFalse( element.parents.containsElement( elementToBeRemoved ) );
			}
		}
		
		[Test]
		public function testThat_addElement_addsToThePlan():void {
			var element:Element = new Element( ElementType.ADVERTISEMENT );
			sut.addElement( element );
			assertTrue( sut.plan.contains( element ) );
		}
		
		[Test]
		public function testThat_addElement_addsDownstreamElementsToThePlan():void {
			var element:Element = new Element( ElementType.AUDIENCE );
			sut.addElement( element );
			assertThat( sut.plan.length, equalTo( 11 ) );
		}
		
		[Test]
		public function testThat_addElement_addsDownstreamElements_forHalfBranches_ToThePlan():void {
			var element:Element = new Element( ElementType.AUDIENCE );
			var childElement:Element = new Element( ElementType.PUBLISHER );
			ElementUtils.linkElements( element, childElement );
			
			sut.addElement( element );
			assertThat( equalTo( 11 ), sut.plan.length );
		}

		[Test]
		public function testThat_addElement_addsPlans_atTheRightLevel():void {
			var newElement:Element = new Element( ElementType.CAMPAIGN );
			sut.addElement( newElement );
			for each( var existingElement:Element in sut.plan ){
				assertFalse( existingElement.descendents.containsElement( newElement ) );
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
			_testThat_elementAddsAtRightLevel( ElementType.ADVERTISEMENT, ElementType.PLACEMENT );
		}
		
		[Test]
		public function testThat_addElement_addsInteractions_atTheRightLevel():void {
			_testThat_elementAddsAtRightLevel( ElementType.INTERACTION, ElementType.ADVERTISEMENT );
		}
		
		[Test]
		public function testThat_plan_collectionChange_dispatches_ElementRendererEvent_SHOW_DETAILS_Event():void {
			var element:Element = new Element(ElementType.CAMPAIGN);
			var dispatcher:IEventDispatcher = new EventDispatcher();
			dispatcher.addEventListener(ElementRendererEvent.SHOW_DETAILS, 
				function (evt:ElementRendererEvent):void {
					assertTrue(evt.element == element);
				}
			);
			sut.dispatcher = dispatcher;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false,false,CollectionEventKind.ADD,-1,-1,[element]);
			sut.plan_collectionChange(event);
		}
		
		[Test]
		public function testThat_removeBranch_removesElementAndAllDescendentElements_andNotAnyOtherElements():void {
			var elementsToBeRemoved:Array = [];
			var elementA:Element = new Element();
			var elementB:Element  = new Element();
			elementsToBeRemoved.push( elementA );
			elementsToBeRemoved.push( elementB );
			ElementUtils.linkElements( elementA, elementB ); // add one child
			elementB = new Element();
			elementsToBeRemoved.push( elementB );
			ElementUtils.linkElements( elementA, elementB ); // add second child
			
			elementA = new Element();
			elementsToBeRemoved.push( elementA );
			ElementUtils.linkElements( elementB, elementA ); // add a child to the second child (now we have three levels of elements)
			
			var previousSize:int = sut.plan.length;
			var element:Element;
			for each( element in elementsToBeRemoved ){
				sut.plan.addItem( element );
			}
			
			assertTrue( (previousSize + elementsToBeRemoved.length) == sut.plan.length );
			
			sut.removeBranch( elementsToBeRemoved[0] as Element );
			
			for each( element in elementsToBeRemoved ){
				assertTrue( !sut.plan.contains( element ) );
			}
			
			assertTrue( previousSize == sut.plan.length );
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
			assertTrue( parentElement.descendents.containsElement( newElement ) );
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
		 * Searches thÍe sut's plan for a child of the given type,
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
			assertTrue( parentElement.descendents.containsElement( childElement ) );
		}
	}
}
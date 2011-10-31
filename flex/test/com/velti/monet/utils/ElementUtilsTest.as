package com.velti.monet.utils {
	import com.velti.monet.models.AdvertisementType;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.InteractionType;
	import com.velti.monet.models.elementData.AdvertisementElementData;
	import com.velti.monet.models.elementData.InteractionElementData;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	
	/**
	 * Tests the ElementUtils class.
	 * 
	 * @author Ian Serlin
	 */	
	public class ElementUtilsTest {
		
		[Before]
		public function setup():void {
		}
		
		[After]
		public function tearDown():void {
		}
		
		[Test]
		public function testThat_elementOrderSpecification_isCorrect():void {
			var elementOrder:Array = [ ElementType.CAMPAIGN, ElementType.AUDIENCE, ElementType.PUBLISHER, ElementType.PLACEMENT, ElementType.ADVERTISEMENT, ElementType.INTERACTION ];
			for( var i:int = 0; i < elementOrder.length; i++ ){
				assertEquals( elementOrder[i], ElementType.ELEMENT_ORDER[i] );
			}
			assertEquals( elementOrder.length, ElementType.ELEMENT_ORDER.length );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forCampaignElements():void {
			var element:Element = new Element( ElementType.CAMPAIGN );
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forAudienceElements():void {
			var element:Element = new Element( ElementType.AUDIENCE );
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forPublisherElements():void {
			var element:Element = new Element( ElementType.PUBLISHER );
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forPlacementElements():void {
			var element:Element = new Element( ElementType.PLACEMENT );
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsTrue_forNull():void {
			assertTrue( ElementUtils.isBlank( null ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forAdvertisements_withAType():void {
			var element:Element = new Element( ElementType.ADVERTISEMENT );
			(element.data as AdvertisementElementData).type = AdvertisementType.AUDIO;
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forAdvertisements_withNonBlankDescendents():void {
			var element:Element = new Element( ElementType.ADVERTISEMENT );
			var child:Element = new Element( ElementType.INTERACTION );
			(child.data as InteractionElementData).type = InteractionType.MOBILE_SITE;
			ElementUtils.linkElements( element, child );
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsTrue_forAdvertisements_withNoType_andNoDescendents():void {
			var element:Element = new Element( ElementType.ADVERTISEMENT );
			assertTrue( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsTrue_forAdvertisements_withNoType_andBlankDescendents():void {
			var element:Element = new Element( ElementType.ADVERTISEMENT );
			var child:Element = new Element( ElementType.INTERACTION );
			ElementUtils.linkElements( element, child );
			assertTrue( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forInteractionElements_withDescendents():void {
			var element:Element = new Element( ElementType.INTERACTION );
			var child:Element = new Element( ElementType.INTERACTION );
			ElementUtils.linkElements( element, child );
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsFalse_forInteractionElements_withAnInteractionType():void {
			var element:Element = new Element( ElementType.INTERACTION );
			(element.data as InteractionElementData).type = InteractionType.SWEEP_STAKES;
			assertFalse( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isBlank_returnsTrue_forInteractionElements_withNoInteractionType_andNoDescendents():void {
			var element:Element = new Element( ElementType.INTERACTION );
			assertTrue( ElementUtils.isBlank( element ) );
		}
		
		[Test]
		public function testThat_isEqual_returnsFalse_ifAIsNull():void {
			var b:Element = new Element( ElementType.CAMPAIGN, "label" );
			assertFalse( ElementUtils.isEqual( null, b ) );
		}
		
		[Test]
		public function testThat_isEqual_returnsFalse_ifBIsNull():void {
			var a:Element = new Element( ElementType.CAMPAIGN, "label" );
			assertFalse( ElementUtils.isEqual( a, null ) );
		}
		
		[Test]
		public function testThat_isEqual_returnsTrue_ifLabelAndTypeAreEqual():void {
			var a:Element = new Element( ElementType.CAMPAIGN, "label" );
			var b:Element = new Element( ElementType.CAMPAIGN, "label" );
			assertTrue( ElementUtils.isEqual( a, b ) );
		}
		
		[Test]
		public function testThat_isEqual_returnsFalse_ifTypesAreDifferent():void {
			var a:Element = new Element( ElementType.CAMPAIGN, "label" );
			var b:Element = new Element( ElementType.AUDIENCE, "label" );
			assertFalse( ElementUtils.isEqual( a, b ) );
		}
		
		[Test]
		public function testThat_isEqual_returnsFalse_ifLabelsAreDifferent():void {
			var a:Element = new Element( ElementType.CAMPAIGN, "label" );
			var b:Element = new Element( ElementType.CAMPAIGN, "label2" );
			assertFalse( ElementUtils.isEqual( a, b ) );
		}
		
		[Test]
		public function testThat_copyConnections_copiesParentsAndDescendents():void {
			var parent:Element = new Element(ElementType.CAMPAIGN);
			var child:Element = new Element(ElementType.AUDIENCE);
			var grandChild:Element = new Element(ElementType.PUBLISHER);
			ElementUtils.linkElements( parent, child );
			ElementUtils.linkElements( child, grandChild );
			
			var secondChild:Element = new Element(ElementType.AUDIENCE);
			
			ElementUtils.copyConnections( child, secondChild );
			
			assertEquals( child.descendents.length, secondChild.descendents.length );
			assertEquals( child.parents.length, secondChild.parents.length );
			
			var element:Element;
			var i:int;
			for( i = 0; i < secondChild.descendents.length; i++ ){
				assertTrue( child.descendents.containsElement( secondChild.descendents.getAt( i ) ) );
			}
			for( i = 0; i < secondChild.parents.length; i++ ){
				assertTrue( child.parents.containsElement( secondChild.parents.getAt( i ) ) );
			}
		}
		
		
		[Test]
		public function testThat_linkElements_linksElements():void {
			var parent:Element = new Element(ElementType.CAMPAIGN);
			var child:Element = new Element(ElementType.AUDIENCE);
			ElementUtils.linkElements( parent, child );
			assertTrue( parent.descendents.containsElement( child ) );
			assertTrue( child.parents.containsElement( parent ) );
			assertTrue( parent.parents.length == 0 );
			assertTrue( child.descendents.length == 0 );
		}
		
		[Test]
		public function testThat_unlinkElements_unlinksElements():void {
			var parent:Element = new Element(ElementType.CAMPAIGN);
			var child:Element = new Element(ElementType.AUDIENCE);
			ElementUtils.linkElements( parent, child );
			ElementUtils.unlinkElements( parent, child );
			assertFalse( parent.descendents.containsElement( child ) );
			assertFalse( child.parents.containsElement( parent ) );
			assertTrue( parent.descendents.length == 0 );
			assertTrue( child.parents.length == 0 );
		}
		
		[Test]
		public function testThat_sortElementsByType_returns0_whenAAndBArePositionallyEqual():void {
			var parent:Element = new Element(ElementType.AUDIENCE);
			var child:Element = new Element(ElementType.AUDIENCE);
			assertEquals( 0, ElementUtils.sortElementsByType( parent, child ) );
		}
		
		[Test]
		public function testThat_sortElementsByType_returnsNegative1_whenAShouldBeBeforeB():void {
			var parent:Element = new Element(ElementType.CAMPAIGN);
			var child:Element = new Element(ElementType.AUDIENCE);
			assertEquals( -1, ElementUtils.sortElementsByType( parent, child ) );
		}
		
		[Test]
		public function testThat_sortElementsByType_returns1_whenBShouldBeBeforeA():void {
			var parent:Element = new Element(ElementType.CAMPAIGN);
			var child:Element = new Element(ElementType.AUDIENCE);
			assertEquals( 1, ElementUtils.sortElementsByType( child, parent ) );
		}
		
	}
}
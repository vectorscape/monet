package com.velti.monet.utils {
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	
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
package com.velti.monet.utils {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.Plan;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;
	
	/**
	 * Tests the PivotUtils class.
	 * 
	 * @author Ian Serlin
	 */	
	public class PivotUtilsTest {
		
		[Before]
		public function setup():void {
		}
		
		[After]
		public function tearDown():void {
		}
		
		[Test]
		public function testThat_getEquivalentElements_returnsOnlyAndAllTheEquivalentElements():void {
			var elementA:Element = new Element( ElementType.CAMPAIGN, "label" );
			var elementB:Element = new Element( ElementType.CAMPAIGN, "label" );
			var elementC:Element = new Element( ElementType.AUDIENCE, "label" );
			var elementD:Element = new Element( ElementType.CAMPAIGN, "label2" );
			var plan:ArrayCollection = new ArrayCollection();
			plan.addItem( elementA );
			plan.addItem( elementB );
			plan.addItem( elementC );
			plan.addItem( elementD );
			
			var result:ArrayCollection =  new ArrayCollection( PivotUtils.getEquivalentElements( elementA, plan ) );
			
			assertThat( result.length, equalTo( 2 ) );
			assertTrue( result.contains( elementA ) );
			assertTrue( result.contains( elementB ) );
		}

		[Test]
		public function testThat_getRelevantElementsForPivoting_returnsAnEmtpyCollection_ifPivotElements_isNull():void {
			var result:IndexedCollection = PivotUtils.getRelevantElementsForPivoting( null );
			
			assertNotNull( result );
			assertThat( result.length, equalTo( 0 ) );
		}
		
		[Test]
		public function testThat_getRelevantElementsForPivoting_returnsAnEmptyCollection_ifPivotElements_isEmpty():void {
			var result:ArrayCollection = PivotUtils.getRelevantElementsForPivoting( [] );
			
			assertNotNull( result );
			assertThat( result.length, equalTo( 0 ) );
		}

		[Test]
		public function testThat_getRelevantElementsForPivoting_returnsTheRelevantElements():void {
			/* This is the graph of nodes we are looking at and we are pivoting on E (and E*).
				A -> B -> E -> G -> K
							-> H
				  -> C -> F -> I
				  -> D -> E* -> J
			*/
			
			var a:Element = new Element(),
				b:Element = new Element(),
				c:Element = new Element(),
				d:Element = new Element(),
				e:Element = new Element(ElementType.ADVERTISEMENT, "pivot node"),
				f:Element = new Element(),
				eStar:Element = new Element(ElementType.ADVERTISEMENT, "pivot node"),
				g:Element = new Element(),
				h:Element = new Element(),
				i:Element = new Element(),
				j:Element = new Element(),
				k:Element = new Element();
			
			// 1st level
			ElementUtils.linkElements( a, b );
			ElementUtils.linkElements( a, c );
			ElementUtils.linkElements( a, d );
			
			// 2nd level
			ElementUtils.linkElements( b, e );
			ElementUtils.linkElements( c, f );
			ElementUtils.linkElements( d, eStar );
			
			// 3rd level
			ElementUtils.linkElements( e, g );
			ElementUtils.linkElements( e, h );
			ElementUtils.linkElements( f, i );
			ElementUtils.linkElements( eStar, j );
			
			// 4th level
			ElementUtils.linkElements( g, k );
			
			var result:IndexedCollection = PivotUtils.getRelevantElementsForPivoting( [e, eStar] );
			
			// quick test length
			assertThat( result.length, equalTo( 9 ) );
			
			var element:Element;
			// test inclusion of all proper elements
			for each( element in [a,b,e,g,k,h,d,eStar,j] ){
				assertTrue( result.contains( element ) );
			}
			
			// test exclusion of all proper elements
			for each( element in [c,f,i] ){
				assertFalse( result.contains( element ) );
			}
		}
		
	}
}
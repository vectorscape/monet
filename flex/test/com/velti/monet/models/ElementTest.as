package com.velti.monet.models {
	
	import mx.resources.ResourceManager;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.object.equalTo;
	
	[ResourceBundle("UI")]
	public class ElementTest 
	{
		
		private static const TEST_ELEMENT_TYPE:ElementType = new ElementType('test_type');
		
		private var sut:Element;
		
		[Before]
		public function setUp():void {
			sut = new Element(TEST_ELEMENT_TYPE, 'test_label');
		}
		
		[After]
		public function tearDown():void {
			sut = null;
		}
		
		[Test]
		public function testThat_element_hasAnElementID():void {
			assertTrue( sut.hasOwnProperty( 'elementID' ) );
		}
		
		[Test]
		public function testThat_element_takesAn_ElementID():void {
			var expected:String = "test_elementID";
			sut = new Element( TEST_ELEMENT_TYPE, 'test_label', expected );
			assertTrue( sut.elementID == expected );
		}
		
		
		[Test]
		public function testThat_element_generatesAn_ElementID():void {
			assertTrue( sut.elementID != null && sut.elementID != '' );
		}
		
		[Test]
		public function testThat_element_hasAType():void {
			assertTrue( sut.hasOwnProperty( 'type' ) );
		}
		
		[Test]
		public function testThat_newElement_acceptsAType():void {
			sut = new Element( TEST_ELEMENT_TYPE, 'test_label' );
			assertThat( sut.type, equalTo( TEST_ELEMENT_TYPE ) );
		}
		
		[Test]
		public function testThat_element_hasALabel():void {
			assertTrue( sut.hasOwnProperty( 'label' ) );
		}
		
		[Test]
		public function testThat_newElement_acceptsALabel():void {
			var expected:String = 'labelcopter'; 
			sut = new Element( TEST_ELEMENT_TYPE, expected );
			assertThat( sut.label, equalTo( expected ) );
		}

		[Test]
		public function testThat_audienceElement_withNoLabel_returnsDefaultLabel():void {
			testDefaultLabelForElementType( ElementType.AUDIENCE );
		}

		[Test]
		public function testThat_publisherElement_withNoLabel_returnsDefaultLabel():void {
			testDefaultLabelForElementType( ElementType.PUBLISHER );
		}

		[Test]
		public function testThat_placementElement_withNoLabel_returnsDefaultLabel():void {
			testDefaultLabelForElementType( ElementType.PLACEMENT );
		}

		[Test]
		public function testThat_contentElement_withNoLabel_returnsDefaultLabel():void {
			testDefaultLabelForElementType( ElementType.ADVERTISEMENT );
		}

		[Test]
		public function testThat_resultsElement_withNoLabel_returnsDefaultLabel():void {
			testDefaultLabelForElementType( ElementType.INTERACTION );
		}
		
		/**
		 * Sets up and tests the element's default label for a particular element type.
		 * 
		 * @param elementType the type of element you want to test the default label for
		 * @return True if the default label was returned, false otherwise 
		 */		
		protected function testDefaultLabelForElementType( elementType:ElementType ):void {
			var defaultLabel:String = ResourceManager.getInstance().getString('UI', elementType.name);
			sut.type = elementType;
			assertThat( sut.label, defaultLabel );
		}
	}
}
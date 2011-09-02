package com.velti.monet.models {
	
	import mx.resources.ResourceManager;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.equalTo;

	public class ElementTest {
		
		private static const TEST_ELEMENT_TYPE:ElementType = new ElementType('test_type');
		
		private var _sut:Element;
		
		[Before]
		public function setUp():void {
			_sut = new Element(TEST_ELEMENT_TYPE, 'test_label');
		}
		
		[After]
		public function tearDown():void {
			_sut = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testThat_element_hasAType():void {
			assertTrue( _sut.hasOwnProperty( 'type' ) );
		}
		
		[Test]
		public function testThat_newElement_acceptsAType():void {
			_sut = new Element( TEST_ELEMENT_TYPE, 'test_label' );
			assertThat( _sut.type, equalTo( TEST_ELEMENT_TYPE ) );
		}
		
		[Test]
		public function testThat_element_hasALabel():void {
			assertTrue( _sut.hasOwnProperty( 'label' ) );
		}
		
		[Test]
		public function testThat_newElement_acceptsALabel():void {
			var expected:String = 'labelcopter'; 
			_sut = new Element( TEST_ELEMENT_TYPE, expected );
			assertThat( _sut.label, equalTo( expected ) );
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
			testDefaultLabelForElementType( ElementType.CONTENT );
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
			_sut.type = elementType;
			assertThat( _sut.label, defaultLabel );
		}
	}
}
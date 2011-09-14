package com.velti.monet.models {
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.equalTo;
	
	[ResourceBundle("UI")]
	public class ElementTest 
	{
		private var _sut:Element;
		
		[Before]
		public function setUp():void {
			_sut = new Element();
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
		public function testThat_element_hasAnElementID():void {
			assertTrue( _sut.hasOwnProperty( 'elementID' ) );
		}
		
		[Test]
		public function testThat_element_takesAn_ElementID():void {
			var expected:String = "test_elementID";
			_sut = new Element();
			_sut.elementID = expected;
			assertTrue( _sut.elementID == expected );
		}
		
		
		[Test]
		public function testThat_element_generatesAn_ElementID():void {
			assertTrue( _sut.elementID != null && _sut.elementID != '' );
		}
		
		[Test]
		public function testThat_element_hasALabel():void {
			assertTrue( _sut.hasOwnProperty( 'label' ) );
		}
		
		[Test]
		public function testThat_newElement_acceptsALabel():void {
			var expected:String = 'labelcopter'; 
			_sut = new Element();
			_sut.label = expected;
			assertThat( _sut.label, equalTo( expected ) );
		}
		
		[Test]
		public function testThat_clone_works():void {
			var actual:Element = _sut.clone();
			assertNotNull(actual);
			assertTrue(_sut.elementID != actual.elementID);
		}
	}
}
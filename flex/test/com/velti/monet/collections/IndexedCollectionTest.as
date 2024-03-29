package com.velti.monet.collections {
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.sameInstance;
	
	public class IndexedCollectionTest {
		
		protected var _target:IndexedCollection;
		
		[Before]
		public function setUp():void {
			_target = new IndexedCollection("id");
		}
		
		[After]
		public function tearDown():void {
			_target = null;
		}
		
		[Test]
		public function testThat_addItemAt_wontAddDuplicateProducts():void {
			var item:Object = { id: "7" };
			_target.addItemAt( item, 0 );
			_target.addItemAt( item, 0 );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testThat_addItem_wontAddDuplicateProducts():void {
			var item:Object = { id: "7" };
			_target.addItem( item );
			_target.addItem( item );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testThat_addItemAt_replacesItemWithTheSameId():void {
			var itemA:Object = { id: "7" };
			var itemB:Object = { id: "7" };
			_target.addItemAt( itemA, 0 );
			_target.addItemAt( itemB, 0 );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testThat_addItem_replacesItemWithTheSameId():void {
			var itemA:Object = { id: "7" };
			var itemB:Object = { id: "7" };
			_target.addItem( itemA );
			_target.addItem( itemB );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testAddItemAt():void {
			var expected:Object = { id: 7 };
			_target.addItem( {} );
			_target.addItem( expected );
			assertThat( _target.getItemAt( 1 ), sameInstance( expected ) );
		}
		
		[Test]
		public function testGetItemByIndex():void {
			var expected:Object = { id: 7 };
			_target.addItem( expected );
			assertThat( _target.getItemByIndex( 7 ), sameInstance( expected ) );
		}
		
		[Test]
		public function testGetSet_indexedProperty():void {
			var expected:String = "name";
			_target = new IndexedCollection( expected );
			assertThat( _target.indexedProperty, equalTo( expected ) );
		}
		
		[Test]
		public function testRemoveAll():void {
			_target = new IndexedCollection();
			_target.addItem( {} );
			_target.addItem( {} );
			_target.addItem( {} );
			_target.removeAll();
			assertThat( _target.length, equalTo( 0 ) );
		}
		
		[Test]
		public function testRemoveItemAt():void {
			var expected:Object = { id: 7 };
			_target.addItem( {} );
			_target.addItem( expected );
			var actual:Object = _target.removeItemAt( 1 );
			assertThat( actual, sameInstance( expected ) );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testRemoveItemByIndex():void {
			var expected:Object = { id: 7 };
			_target.addItem( {} );
			_target.addItem( expected );
			var actual:Object = _target.removeItemByIndex( 7 );
			assertThat( actual, sameInstance( expected ) );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testSetItemAt():void {
			var expected:Object = { id: 7 };
			_target.addItem( {} );
			_target.setItemAt( expected, 0 );
			assertThat( _target.getItemAt( 0 ), sameInstance( expected ) );
			assertThat( _target.length, equalTo( 1 ) );
		}
		
		[Test]
		public function testSetItemByIndex():void {
			var expected:Object = { id: 7 };
			_target.addItem( { id: 7 } );
			_target.setItemByIndex( expected );
			assertThat( _target.getItemAt( 0 ), sameInstance( expected ) );
			assertThat( _target.length, equalTo( 1 ) );
		}
	}
}
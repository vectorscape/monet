		import com.velti.monet.VectorBuilder;
		import flexunit.framework.Assert;
		import org.flexunit.asserts.assertEquals;
		import org.hamcrest.assertThat;
		import org.hamcrest.collection.arrayWithSize;
		import org.hamcrest.collection.emptyArray;
		import org.hamcrest.collection.hasItem;
		import org.hamcrest.collection.hasItems;
		import org.hamcrest.core.not;
		import org.hamcrest.object.equalTo;
	
		protected var collection:Object;
		protected var vectorBuilder:VectorBuilder = new VectorBuilder();
		
		[Before]
		public function setUp():void {
			collection = new collectionClass();
		}
		
		[After]
		public function tearDown():void {
			collection = null;
		}
		
		[Test]
		public function testAdd():void {
			var expected:Object = new itemClass();
			var actual:Object = collection.add(expected);
			assertEquals(expected,actual);
			assertThat(collection,hasItem(expected));
		}
		
		[Test]
		public function testAddAt():void {
			var expected:Object = new itemClass();
			collection.add(new itemClass());
			collection.add(new itemClass());
			var actual:Object = collection.addAt(expected,1);
			assertEquals(expected,actual);
			assertEquals(collection[1],expected);
		}
		
		[Test]
		public function testConcat():void {
			assertThat(collection.source,arrayWithSize(0));
			var expected:Object = vectorBuilder.build([new itemClass(),new itemClass()],itemClass);
			collection.concat(expected);
			assertThat(collection.source,arrayWithSize(2));
		}
		
		[Test]
		public function testFind():void {
			var expected1:Object = new itemClass();
			var expected2:Object = new itemClass();
			expected1[propertyToFind] = "asdf";
			expected2[propertyToFind] = "asdf";
			collection.add(new itemClass());
			collection.add(expected1);
			collection.add(new itemClass());
			collection.add(expected2);
			var actual:Object = collection.find(propertyToFind,"asdf");
			assertEquals(expected1,actual[0]);
			assertEquals(expected2,actual[1]);
		}
		
		[Test]
		public function testGetAt():void {
			var expected:Object = new itemClass();
			collection.add(new itemClass());
			collection.add(expected);
			collection.add(new itemClass());
			var actual:Object = collection.getAt(1);
			assertEquals(expected,actual);
		}
		
		[Test]
		public function testGetIndex():void {
			var expected:int = 1;
			var obj:Object = new itemClass();
			collection.add(new itemClass());
			collection.add(obj);
			collection.add(new itemClass());
			var actual:int = collection.getIndex(obj);
			assertEquals(expected,actual);
		}
		
		[Test]
		public function testRemove():void {
			assertThat(collection.source,arrayWithSize(0));
			var expected:Object = new itemClass();
			collection.add(new itemClass());
			collection.add(expected);
			collection.add(new itemClass());
			assertThat(collection.source,arrayWithSize(3));
			var actual:Object = collection.remove(expected);
			assertThat(collection.source,arrayWithSize(2));
			assertEquals(expected,actual);
			assertThat(collection,not(hasItem(expected)));
		}
		
		[Test]
		public function testRemoveAt():void {
			assertThat(collection.source,arrayWithSize(0));
			var expected:Object = new itemClass();
			collection.add(new itemClass());
			collection.add(expected);
			collection.add(new itemClass());
			assertThat(collection.source,arrayWithSize(3));
			var actual:Object = collection.removeAt(1);
			assertThat(collection.source,arrayWithSize(2));
			assertEquals(expected,actual);
			assertThat(collection,not(hasItem(expected)));
		}
		
		[Test]
		public function testReplace():void {
			var expected:Object = vectorBuilder.build([new itemClass(),new itemClass(),new itemClass()],itemClass);
			collection.concat(expected);
			var obj1:Object = new itemClass();
			var obj2:Object = new itemClass();
			var objects:Object = vectorBuilder.build([obj1,obj2],itemClass);
			var actual:Object = collection.replace(objects);
			assertThat(collection.source,arrayWithSize(2));
			assertThat(actual,hasItems(equalTo(expected[0]),equalTo(expected[1]),equalTo(expected[2])));
			assertThat(collection,hasItem(obj1));
			assertThat(collection,hasItem(obj2));
		}
		
		[Test]
		public function testSetAt():void {
			var expected:Object = new itemClass();
			collection.add(new itemClass());
			collection.add(expected);
			collection.add(new itemClass());
			var obj:Object = new itemClass();
			var actual:Object = collection.setAt(obj,1);
			assertEquals(expected,actual);
			assertEquals(obj,collection[1]);
		}
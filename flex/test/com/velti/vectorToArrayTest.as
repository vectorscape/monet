package com.velti
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.isA;
	

	public class vectorToArrayTest
	{		
		[Test] [Ignore]
		public function testThat_vectorToArray_succeeds():void {
			var expected:Array = [1,3,5,9,undefined];
			var actual:Array = vectorToArray(Vector.<int>(expected));
			assertThat(expected,actual);
			assertThat([1, 2, 3], everyItem(isA(int)));
		}
	}
}
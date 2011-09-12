package com.velti.monet.models
{
	
	import com.velti.monet.collections.IndexedCollection;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.nullValue;

	public class CampaignTest
	{
		private var _sut:Campaign;
		
		[Before]
		public function setUp():void
		{
			_sut = new Campaign();
		}
		
		[After]
		public function tearDown():void
		{
			_sut = null;
		}
		
	}
}
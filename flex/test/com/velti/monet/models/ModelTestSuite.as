package com.velti.monet.models
{
	import com.velti.monet.models.ElementTest;
	import com.velti.monet.models.PlanTest;
	import com.velti.monet.models.elementData.ElementDataTest;
	import com.velti.monet.models.elementData.ElementDataTestSuite;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ModelTestSuite
	{
		public var ct:com.velti.monet.models.PlanTest;
		public var et:com.velti.monet.models.ElementTest;
		public var dot:DataObjectTest;
		public var edt:ElementDataTestSuite;
	}
}
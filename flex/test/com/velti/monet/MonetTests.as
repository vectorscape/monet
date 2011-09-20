package com.velti.monet
{
	import com.velti.monet.collections.IndexedCollectionTest;
	import com.velti.monet.controllers.ControllerTests;
	import com.velti.monet.controllers.ErrorControllerTest;
	import com.velti.monet.models.ModelTestSuite;
	import com.velti.monet.services.PlanServiceTest;
	import com.velti.monet.utils.URLUtilTest;
	import com.velti.monet.utils.UtilsTests;
	
	[ResourceBundle("UI")]
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	/**
	 * Test suite that contains all the tests for the Monet project.
	 * @author Clint Modien
	 * 
	 */	
	public class MonetTests
	{
		/**
		 * Utils Test Suite 
		 */		
		public var utilsTests:UtilsTests;
		/**
		 * Controllers Test Suite 
		 */		
		public var controllerTests:ControllerTests;
		/**
		 * Model Test Suite 
		 */		
		public var modelTests:ModelTestSuite;
		
		public var ict:IndexedCollectionTest;
		
		public var pst:PlanServiceTest;
	}
}
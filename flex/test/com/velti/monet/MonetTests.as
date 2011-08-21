package com.velti.monet
{
	import com.velti.monet.controllers.ErrorControllerTest;
	import com.velti.monet.utils.URLUtilTest;
	
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
		 * uut 
		 */		
		public var uut:URLUtilTest;
		/**
		 * ect
		 */		
		public var ect:ErrorControllerTest;
	}
}
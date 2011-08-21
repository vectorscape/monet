package com.velti.monet.controllers
{
	import flexunit.framework.Assert;
	
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	/**
	 * Tests the ErrorController 
	 * @author Clint Modien
	 * 
	 */	
	public class ErrorControllerTest
	{	
		/**
		 * The suite under test (sut) 
		 */		
		public var sut:ErrorController;
		/**
		 * setup method 
		 */		
		[Before]
		public function setUp():void {
			sut = new ErrorController();
		}
		/**
		 * tearDown method 
		 */		
		[After]
		public function tearDown():void {
			sut = null;
		}
		/**
		 * Tests that the fault function succeeds 
		 */		
		[Test]
		public function testService_fault():void {
			var e:FaultEvent = new FaultEvent(FaultEvent.FAULT,false,true,new Fault("asdf","asdf2"));
			var expected:String = e.toString();
			var actual:String;
			sut.logFunction = function(msg:String):void {
				actual = msg;
			}
			sut.service_fault(e);
			assertTrue(actual.indexOf(expected) != -1);
		}
		/**
		 * Tests that serviceFault handles null params 
		 */		
		[Test]
		public function testService_fault_handlesNull():void { // NO PMD
			var e:FaultEvent = null;
			var expected:String = ErrorController.NULL_MSG;
			var actual:String;
			sut.logFunction = function(msg:String):void {
				actual = msg;
			}
			sut.service_fault(e);
			assertEquals(expected,actual);
		}
	}
}
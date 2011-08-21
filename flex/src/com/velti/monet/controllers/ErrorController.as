package com.velti.monet.controllers
{
	import mx.rpc.events.FaultEvent;
	
	import org.osflash.thunderbolt.Logger;

	/**
	 * Handles errors in the project 
	 * @author Clint Modien
	 * 
	 */	
	public class ErrorController
	{
		/**
		 * The message to log if null was encounted.
		 */		
		internal static const NULL_MSG:String = "null encountered";
		
		/**
		 * The function used to log error messages. 
		 */		
		internal var logFunction:Function = Logger.error;
		/**
		 * The function to globaly handle all service faults;
		 * @param e The fault event from a service.
		 * 
		 */		
		public function service_fault(e:FaultEvent):void {
			if(e)
				logFunction("FaultFunction Error - " + e.toString());
			else
				logFunction(NULL_MSG);
		}
	}
}
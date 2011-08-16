package com.velti.monet.controllers
{
	import mx.rpc.events.FaultEvent;
	
	import org.osflash.thunderbolt.Logger;

	public class ErrorController
	{
		public function service_fault(e:FaultEvent):void {
			Logger.error("FaultFunction Error - " + e.toString());
		}
	}
}
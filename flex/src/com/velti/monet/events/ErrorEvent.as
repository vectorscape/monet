package com.velti.monet.events
{
	public class ErrorEvent
	{
		public static const APP_ERROR:String = "error.appError";
		public var error:Error;
		
		public function ErrorEvent(e:Error) {
			this.error = e;
		}
	}
}
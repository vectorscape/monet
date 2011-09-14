package com.velti.monet.events
{
	/**
	 * A generic event that gets dispatched if an erro in the app is
	 * encountered. 
	 * @author Clint Modien
	 * 
	 */	
	public class ErrorEvent extends BaseEvent
	{
		/**
		 * A constant denoting a generic app error. 
		 */		
		public static const APP_ERROR:String = "error.appError";
		/**
		 * The error that was encountered. 
		 */		
		public var error:Error;
		/**
		 * ctor
		 * @param e The error was encountered and is assigned to the <code>error</code>
		 * property.
		 * 
		 */		
		public function ErrorEvent(e:Error) {
			this.error = e;
			super( APP_ERROR );
		}
	}
}
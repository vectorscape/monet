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
		private var _error:Error;
		/**
		 * The error that was encountered. 
		 */		
		public function get error():Error {
			return _error;
		}
		/**
		 * ctor
		 * @param e The error was encountered and is assigned to the <code>error</code>
		 * property.
		 * 
		 */		
		public function ErrorEvent(e:Error) {
			this._error = e;
			super( APP_ERROR );
		}
	}
}
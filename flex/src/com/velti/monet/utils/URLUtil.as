package com.velti.monet.utils
{	
	import flash.external.ExternalInterface;
	
	import mx.core.Application;
	import mx.utils.ObjectProxy;
	
	/**
	 * A util for retrieving parts of the application url
	 * @author Clint Modien
	 * 
	 */	
	public class URLUtil
	{
		internal static const UNEXPECTED_URL_FORMAT:String = "1.0 unexpected url format: ";
		
		/**
		 * The url of the application. 
		 */		
		internal static var appUrl:String;
		/**
		 * Returns the base url from the full url.
		 * If the swf is loaded from http://asdf.com
		 * it will return asdf.com 
		 * @return the base url from the full url.
		 * 
		 */		
		public static function get baseURL():String {
			if(!appUrl) appUrl = Application.application.url;
			var parts:Array = appUrl.split("/");
			if(parts.length < 3) return "1.0 unexpected url format: " + appUrl;
			if(parts[2] == "") return "1.1 unexpected url format: " + appUrl;
			parts = parts[2].toString().split(":");
			if(parts.length < 1) return "1.2 unexpected url format: "+ appUrl;
			return parts[0].toString();
		}
		/**
		 * The url parameter cache we use because we don't need to parse this everytime.
		 * We don't expect the url params change.
		 */		
		internal static var _params:ObjectProxy;
		/**
		 * Gets url parameters appeneded to the app url as name value pairs
		 * that can be iterated over with a for in loop or directly
		 * accessed via returnObj["debug"] would return true on a url like: 
		 * http://app.com/main.html?debug=true
		 */	
		public static function get urlParams():ObjectProxy {
			
			if(_params) return _params;
			_params = new ObjectProxy(); 
			if(!ExternalInterface.available) return _params;
			
			var fullUrl:String = ExternalInterface.call('eval','document.location.href'); 
			
			var paramStr:String = fullUrl.split('?')[1];
			if (paramStr != null) {
				var params:Array = paramStr.split('&');
				for (var i:int = 0; i < params.length; i++) {
					var kv:Array = params[i].split('=');
					_params[kv[0]] = kv[1];
				}
			}
			return _params;
		}
	}
}
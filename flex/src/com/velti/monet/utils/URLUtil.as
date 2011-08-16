package com.velti.monet.utils
{	
	import flash.external.ExternalInterface;
	
	import mx.core.Application;
	import mx.utils.ObjectProxy;

	public class URLUtil
	{
		internal static var app:Object = Application.application;
		/**
		 * Returns the base url from the full url.
		 * If the swf is loaded from http://asdf.com
		 * it will return asdf.com 
		 * @return the base url from the full url.
		 * 
		 */		
		public static function get baseURL():String {
			var url:String = app.url;
			var parts:Array = url.split("/");
			if(parts.length < 3) return "1.0 unexpected url format: " + url;
			if(parts[2] == "") return "1.1 unexpected url format: " + url;
			parts = parts[2].toString().split(":");
			if(parts.length < 1) return "1.2 unexpected url format: "+ url;
			return parts[0].toString();
		}
		private static var _params:ObjectProxy;
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
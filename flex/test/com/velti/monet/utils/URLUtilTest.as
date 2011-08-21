package com.velti.monet.utils
{
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertEquals;
	/**
	 * Tests the url util class 
	 * @author Clint Modien
	 * 
	 */	
	public class URLUtilTest
	{		
		private const PROTOCOL:String = "http";
		private const BASE:String = "asdf.com";
		private const PORT:String = "8080";
		private const PROTOCOLURL:String = PROTOCOL+"://"+BASE+":"+PORT+"/wtf";
		private const URL:String =  PROTOCOL+"://"+BASE+"/wtf";
		
		/**
		 * Tests that baseURL works 
		 */		
		[Test]
		public function testGet_baseURL():void {
			URLUtil.appUrl = URL;
			assertEquals(BASE,URLUtil.baseURL);
		}
		
		/**
		 * Tests that baseURL works with a protocol.
		 */		
		[Test]
		public function testGet_baseURL_withProtocol():void { // NO PMD
			URLUtil.appUrl = PROTOCOLURL;
			assertEquals(BASE,URLUtil.baseURL);
		}
	}
}
package com.velti.monet.utils
{
	import flexunit.framework.Assert;
	
	import mx.utils.ObjectProxy;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

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
		
		private const LOCAL_HARD_DRIVE:String = "c:\\program files\\some path\\app.swf";
		
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
		
		/**
		 * Tests that baseURL works with a local file.
		 */		
		[Test]
		public function testGet_baseURL_handlesLocalHardDrive():void { // NO PMD
			URLUtil.appUrl = LOCAL_HARD_DRIVE;
			assertTrue(URLUtil.baseURL.indexOf(URLUtil.UNEXPECTED_URL_FORMAT) > -1);
		}
		
		/**
		 * Tests that get urlParams works with a local file.
		 */		
		[Test]
		public function testGet_urlParams_handlesLocalHardDrive():void { // NO PMD
			assertTrue(URLUtil.urlParams is ObjectProxy);
		}
	}
}
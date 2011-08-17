package com.velti.monet.utils
{
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertEquals;
	
	public class URLUtilTest
	{		
		private const PROTOCOL:String = "http";
		private const BASE:String = "asdf.com";
		private const PORT:String = "8080";
		private const PROTOCOLURL:String = PROTOCOL+"://"+BASE+":"+PORT+"/wtf";
		private const URL:String =  PROTOCOL+"://"+BASE+"/wtf";
		
		[Test]
		public function testGet_baseURL():void {
			URLUtil.app = {url:URL};
			assertEquals(BASE,URLUtil.baseURL);
		}
		
		[Test]
		public function testGet_baseURL_withProtocol():void {
			URLUtil.app = {url:PROTOCOLURL};
			assertEquals(BASE,URLUtil.baseURL);
		}
	}
}
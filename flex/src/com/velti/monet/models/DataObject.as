package com.velti.monet.models
{
	import flash.events.EventDispatcher;
	
	import mx.utils.ObjectUtil;
	/**
	 * Used to denote all objects that function as objects that container data. 
	 */	
	[RemoteClass]
	public class DataObject extends EventDispatcher implements ISerializable
	{
		/**
		 * Constructor 
		 * 
		 */		
		public function DataObject() {
			super();
		}
	}
}
package com.velti.monet.models
{
	import flash.events.EventDispatcher;
	
	import mx.utils.ObjectUtil;
	/**
	 * Used to denote all objects that function as objects that container data. 
	 */	
	[RemoteClass]
	public class DataObject extends EventDispatcher implements ISerializable, ICloneable
	{
		/**
		 * Constructor 
		 * 
		 */		
		public function DataObject() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():ICloneable { // NO PMD
			return ObjectUtil.copy(this) as ICloneable;
		}
	}
}
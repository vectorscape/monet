package com.velti.monet.models
{
	import flash.events.EventDispatcher;
	
	import mx.utils.ObjectUtil;
	
	[RemoteClass]
	public class DataObject extends EventDispatcher implements ISerializable, ICloneable
	{
		public function DataObject() {
			super();
		}
		
		public function clone():Object {
			return ObjectUtil.copy(this);
		}
	}
}
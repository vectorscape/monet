package com.velti.monet.events
{
	import flash.events.Event;

	public class BaseEvent extends Event
	{
		public function BaseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return this;
		}
	}
}
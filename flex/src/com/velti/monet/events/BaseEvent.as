package com.velti.monet.events
{
	import flash.events.Event;
	
	/**
	 * A base event that overrides clone to not make copies of events.
	 * @author Clint Modien
	 * 
	 */	
	public class BaseEvent extends Event
	{
		/**
		 * Constructor
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function BaseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		/**
		 * @inheritDoc
		 */
		override public function clone():Event {
			return this;
		}
	}
}
package com.velti.monet.events
{
	import com.velti.monet.models.Element;
	
	import flash.events.Event;
	
	public class MagicWandEvent extends Event
	{
		public static const TOOL_CHOSEN:String = "magicWandToolChosen";
		public static const FIRST_SELECTED:String = "magicWandFirstSelected";
		public static const SUBSEQUENT_SELECTED:String = "magicWandSubsequentSelected";
		
		public var element:Element;
		
		public function MagicWandEvent(type:String, element:Element = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.element = element;
		}
	}
}
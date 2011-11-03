package com.velti.monet.models
{
	public class SubType
	{
		
		/**
		 * Name of this interaction type. 
		 */
		[Bindable]
		public var label:String;
		
		/**
		 * Icon that visually represents this interaction type. 
		 */		
		public var icon:Class;

		/**
		 * Constructor
		 *  
		 * @param label
		 * @param icon
		 */		
		public function SubType(label:String, icon:Class){
			this.label = label;
			this.icon = icon;
		}
		
	}
}
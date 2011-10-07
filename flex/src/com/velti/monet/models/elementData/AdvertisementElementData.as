package com.velti.monet.models.elementData
{
	import com.velti.monet.models.AdvertisementType;
	/**
	 * Used to list the Advertisement data set
	 * @author Clint Modien
	 * 
	 */	
	public class AdvertisementElementData extends ElementData
	{
		/**
		 * The name of the current element 
		 */		
		[Bindable][VeltiInspectable]
		public var name:String;
		/**
		 * The type of the current element 
		 */		
		[Bindable][VeltiInspectable]
		public var type:AdvertisementType;
		/**
		 * The actionType to use 
		 */		
		[Bindable][VeltiInspectable]
		public var actionType:String;
		/**
		 * The text to associate with the action
		 */		
		[Bindable][VeltiInspectable]
		public var actionText:String;
		/**
		 * The text associated with the add 
		 */		
		[Bindable][VeltiInspectable]
		public var addText:String;
		
		/**
		 * @inheritDoc
		 * 
		 */
		override public function get isValid():Boolean {
			return name != null && name != ""
				&& type != null
				&& actionType != null && actionType != ""
				&& actionText != null && actionText != "";
		}
		/**
		 * @inheritDoc
		 */
		[Bindable]
		override public function get labelString():String {
			return name;
		} override public function set labelString(v:String):void {
			name = v;
		}
	}
}
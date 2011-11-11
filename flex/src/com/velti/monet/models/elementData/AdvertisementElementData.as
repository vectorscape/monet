package com.velti.monet.models.elementData
{
	import com.velti.monet.models.AdvertisementType;
	import com.velti.monet.models.CreativeLibraryItem;

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
		[Bindable][VeltiInspectable][Duplicatable]
		public var name:String;
		/**
		 * The type of the current element 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var type:AdvertisementType;
		/**
		 * The type of the current element 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var creativeLibraryItem:CreativeLibraryItem;
		/**
		 * The actionType to use 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var actionType:String;
		/**
		 * The text to associate with the action
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var actionText:String;
		/**
		 * The text associated with the add 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var addText:String;
		/**
		 * The start date to display the ad 
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var startDate:Date;
		/**
		 * The date to stop the ad
		 */		
		[Bindable][VeltiInspectable][Duplicatable]
		public var endDate:Date;
		
		/**
		 * @inheritDoc
		 * 
		 */
		override public function get isValid():Boolean {
			return name != null && name != ""
				&& type != null
				&& actionType != null && actionType != ""
				&& actionText != null && actionText != ""
				&& creativeLibraryItem != null
				&& endDate != null
				&& startDate != null
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
		
		override public function duplicate():ElementData {
			return copyValues( new AdvertisementElementData() );
		}
	}
}
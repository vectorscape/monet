package com.velti.monet.models.elementData
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	/**
	 * The data for an Audience element
	 * @author Clint Modien
	 * 
	 */	
	public class AudienceElementData extends ElementData
	{
		/**
		 * @private 
		 */		
		internal var resMgr:IResourceManager = ResourceManager.getInstance();
			
		/**
		 * The Array of genders (e.g. male, female) 
		 */		
		[Bindable]
		[VeltiInspectable]
		[ArrayElementType("String")]
		public var genders:Array;
		/**
		 * The array of age groups. (e.g. 17-26, 27-32) 
		 */		
		[Bindable][VeltiInspectable]
		[ArrayElementType("String")]
		public var ages:Array;
		/**
		 * @inheritDoc 
		 */
		[Bindable]
		override public function get labelString():String {
			return isValid ? resMgr.getString("UI","audienceTarget") : resMgr.getString("UI","audience");
		} override public function set labelString(v:String):void {
			; // NO PMD
		}
		/**
		 * @inheritDoc 
		 */
		override public function get isValid():Boolean {
			return ages != null || genders != null;
		}
	}
}
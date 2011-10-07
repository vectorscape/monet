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
		 * Temp val for publishers and placements 
		 */		
		[Bindable]
		public var publishersAndPlacements:XML =  <root>
				<node label="CNN">
					<node label="Any" />
					<node label="Home Page"  />
					<node label="Basketball hub"  />
					<node label="Baseball hub"  />
					<node label="NFL hub"  />
					<node label="Soccer hub"  />
				</node>
				<node label="ESPN">
					<node label="Any"  />
					<node label="Home Page"  />
					<node label="NBA hub"  />
					<node label="MLB hub"  />
					<node label="NFL hub"  />
					<node label="Soccer hub"  />
				</node>
				<node label="TMZ">
					<node label="Any"  />
					<node label="Home Page"  />
					<node label="Contest Page"  />
					<node label="Baseball hub"  />
					<node label="NFL hub"  />
					<node label="Soccer hub"  />
				</node>
				<node label="Washington Post">
					<node label="Any" />
					<node label="Revolution Hub" />
				</node>
			</root>;
		
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
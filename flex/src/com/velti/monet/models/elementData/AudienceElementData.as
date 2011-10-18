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
		public var publishersAndPlacements:XML =  
			<root>
				<node label="CNN" id="cnn">
					<node label="Any" id="cnn.any"/>
					<node label="Home Page"  id="cnn.home"/>
					<node label="Basketball hub"  id="cnn.basketball"/>
					<node label="Baseball hub"  id="cnn.baseball"/>
					<node label="NFL hub"  id="cnn.football"/>
					<node label="Soccer hub"  id="cnn.soccer"/>
				</node>
				<node label="Fox" id="fox">
					<node label="Any" id="fox.any" />
				</node>
				<node label="ESPN" id="espn">
					<node label="Any"  id="espn.any"/>
					<node label="Home Page"  id="espn.home"/>
					<node label="NBA hub"  id="espn.nba"/>
					<node label="MLB hub"  id="espn.mlb"/>
					<node label="NFL hub"  id="espn.nfl"/>
					<node label="Soccer hub"  id="espn.soccer"/>
				</node>
				<node label="TMZ" id="tmz">
					<node label="Any"  id="tmz"/>
					<node label="Home Page"  id="tmz"/>
					<node label="Contest Page"  id="tmz"/>
					<node label="Baseball hub"  id="tmz"/>
					<node label="NFL hub"  id="tmz"/>
					<node label="Soccer hub"  id="tmz"/>
				</node>
				<node label="Washington Post" id="washingtonpost">
					<node label="Any" id="washingtonpost.any"/>
					<node label="Revolution Hub" id="washingtonpost.revolution"/>
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
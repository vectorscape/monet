package com.velti.monet.models.elementData
{
	import com.velti.monet.models.Element;
	
	import flash.events.Event;
	
	import mx.events.PropertyChangeEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	/**
	 * The element data for a publisher 
	 * @author Clint Modien
	 * 
	 */	
	public class PlacementElementData extends ElementData
	{
		
		public static const NODE_CHANGED:String = "nodeChanged";
		
		/**
		 * @private 
		 */		
		internal var resMgr:IResourceManager = ResourceManager.getInstance();
		/**
		 * The date the flight starts on. 
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var startsOn:Date;
		/**
		 * The date the flight ends on.
		 */
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var endsOn:Date;
		/**
		 * The part of the day to show the add in this 
		 * placement.
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var dayPart:String = "All Day";
		/**
		 * Whether or not to apply the flighting settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var applyFlightingToAll:Boolean;
		/**
		 * A cap to limit the fequency of ads showing up for this placement.
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var frequencyCapping:String = "No Limit";
		/**
		 * How often to show the ads for this placement
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var pacing:String = "Spread evenly";
		/**
		 * Whether or not to apply the capping settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var applyCappingToAll:Boolean;
		/**
		 * The max budget for this placement
		 */
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var maxBudget:Number = 0;
		/**
		 * The min budget for this placement 
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var minBudget:Number = 0;
		/**
		 * The Cost per Impression
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var cpm:Boolean;
		/**
		 * The max cost per Impression
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var cpmMax:Number = 0;
		/**
		 * The cost per Click
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var cpc:Boolean;
		/**
		 * The min cost per Click
		 */		
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var cpcMin:Number = 0;
		/**
		 * Whether or not to apply the budget settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
		[Duplicatable]
		public var applyBudgetToAll:Boolean;
		
		
		/**
		 * The name of the publisher or placement 
		 */
		[VeltiInspectable]
		[Bindable(event="nodeChanged")]
		public function get name():String {
			return node ? node.@label : "";
		}
		/**
		 * The placement xml node from audiences publisherPlacement xml
		 */		
		[Bindable][Duplicatable]
		public var node:XML;
		/**
		 * A ref to the element that this data object belongs too. 
		 */
		public var element:Element;
		
		[Bindable(event="elementChanged")]
		public function get placements():XMLList {
			return publishersAndPlacements ? publishersAndPlacements..node : null;
		}
		
		/**
		 * An XML representation of publishers and placements to choose from.
		 */
		[Bindable(event="elementChanged")]
		public function get publishersAndPlacements():XML {
			if(!element) return null;
			var returnVal:XML = new XML();
			var publisher:Element = element.parents.getAt(0);
			if(publisher) 
				returnVal = PublisherElementData(publisher.data).node;
			return returnVal;
		}
		
		/**
		 * @inheritDoc 
		 */
		[Bindable]
		override public function get labelString():String {
			return node ? name : resMgr.getString("UI","placement");
		} override public function set labelString(v:String):void {
			; // NO PMD
		}
		
		/**
		 * @inheritDoc
		 * 
		 */
		[Bindable(event="propertyChange")]
		override public function get isValid():Boolean {
			if(!node ||
			(!startsOn) ||
			(!endsOn) ||
			(!dayPart || dayPart == "")  ||
			(!frequencyCapping)  ||
			(!pacing)  ||
			(isNaN(maxBudget) || maxBudget == 0)  ||
			(!cpc && !cpm)) return false;
			return true;
		}
		
		override public function duplicate():ElementData {
			return copyValues( new PlacementElementData() );
		}
	}
}
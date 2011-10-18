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
		public var startsOn:Date;
		/**
		 * The date the flight ends on.
		 */
		[VeltiInspectable]
		[Bindable]
		public var endsOn:Date;
		/**
		 * The part of the day to show the add in this 
		 * placement.
		 */		
		[VeltiInspectable]
		[Bindable]
		public var dayPart:String = "";
		/**
		 * Whether or not to apply the flighting settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
		public var applyFlightingToAll:Boolean;
		/**
		 * A cap to limit the fequency of ads showing up for this placement.
		 */		
		[VeltiInspectable]
		[Bindable]
		public var frequencyCapping:String = "";
		/**
		 * How often to show the ads for this placement
		 */		
		[VeltiInspectable]
		[Bindable]
		public var pacing:String = "";
		/**
		 * Whether or not to apply the capping settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
		public var applyCappingToAll:Boolean;
		/**
		 * What type of ad unit to apply
		 */
		[VeltiInspectable]
		[Bindable]
		public var staticBanner:Boolean;
		/**
		 * What type of ad unit to apply
		 */
		[VeltiInspectable]
		[Bindable]
		public var richMedia:Boolean;
		/**
		 * What type of ad unit to apply
		 */
		[VeltiInspectable]
		[Bindable]
		public var video:Boolean;
		/**
		 * What type of ad unit to apply
		 */
		[VeltiInspectable]
		[Bindable]
		public var audio:Boolean;
		/**
		 * What type of ad unit to apply
		 */
		[VeltiInspectable]
		[Bindable]
		public var text:Boolean;
		/**
		 * Whether or not to apply the ad unit settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
		public var applyAdUnitToAll:Boolean;
		/**
		 * The max budget for this placement
		 */
		[VeltiInspectable]
		[Bindable]
		public var maxBudget:Number = 0;
		/**
		 * The min budget for this placement 
		 */		
		[VeltiInspectable]
		[Bindable]
		public var minBudget:Number = 0;
		/**
		 * The Cost per ?
		 */		
		[VeltiInspectable]
		[Bindable]
		public var cpm:Boolean;
		/**
		 * The max cost per ?
		 */		
		[VeltiInspectable]
		[Bindable]
		public var cpmMax:Number = 0;
		/**
		 * The cost per ? 
		 */		
		[VeltiInspectable]
		[Bindable]
		public var cpc:Boolean;
		/**
		 * The min cost per ?
		 */		
		[VeltiInspectable]
		[Bindable]
		public var cpcMin:Number = 0;
		/**
		 * Whether or not to apply the budget settings to all placements for this publisher
		 */
		[VeltiInspectable]
		[Bindable]
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
		[Bindable]
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
			(!staticBanner && !richMedia && !video && !audio && !text)  ||
			(isNaN(maxBudget) || maxBudget == 0)  ||
			(!cpc && !cpm)) return false;
			return true;
		}
	}
}
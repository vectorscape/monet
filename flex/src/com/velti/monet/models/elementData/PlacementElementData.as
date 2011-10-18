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
		
		private var _node:XML;
		private var _element:Element;
		
		[VeltiInspectable]
		[Bindable]
		public var startsOn:Date;
		[VeltiInspectable]
		[Bindable]
		public var endsOn:Date;
		[VeltiInspectable]
		[Bindable]
		public var dayPart:String = "";
		[VeltiInspectable]
		[Bindable]
		public var applyFlightingToAll:Boolean;
		
		[VeltiInspectable]
		[Bindable]
		public var frequencyCapping:String = "";
		[VeltiInspectable]
		[Bindable]
		public var pacing:String = "";
		[VeltiInspectable]
		[Bindable]
		public var applyCappingToAll:Boolean;
		
		[VeltiInspectable]
		[Bindable]
		public var staticBanner:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var richMedia:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var video:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var audio:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var text:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var applyAdUnitToAll:Boolean;
		
		[VeltiInspectable]
		[Bindable]
		public var maxBudget:Number = 0;
		[VeltiInspectable]
		[Bindable]
		public var minBudget:Number = 0;
		[VeltiInspectable]
		[Bindable]
		public var cpm:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var cpmMax:Number = 0;
		[VeltiInspectable]
		[Bindable]
		public var cpc:Boolean;
		[VeltiInspectable]
		[Bindable]
		public var cpcMin:Number = 0;
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
			if(!node) return false;
			if(!startsOn) return false;
			if(!endsOn) return false;
			if(!dayPart || dayPart == "")  return false;
			if(!frequencyCapping)  return false;
			if(!pacing)  return false;
			if(!staticBanner && !richMedia && !video && !audio && !text)  return false;
			if(isNaN(maxBudget) || maxBudget == 0)  return false;
			if(!cpc && !cpm) return false;
			return true;
		}
	}
}
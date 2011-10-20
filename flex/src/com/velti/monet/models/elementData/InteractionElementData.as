package com.velti.monet.models.elementData
{	
	import com.velti.monet.models.InteractionType;

	/**
	 * Element data for an interaction element
	 * @author Clint Modien
	 * 
	 */	
	public class InteractionElementData extends ElementData
	{
		/**
		 * The name of the current element 
		 */		
		[Bindable][VeltiInspectable]
		public var name:String;
		/**
		 * What it was built from 
		 */		
		[Bindable][VeltiInspectable]
		public var builtFrom:String;
		/**
		 * What tool the interactin was created using
		 */
		[Bindable][VeltiInspectable]
		public var createdUsing:String;
		/**
		 * What site name the interaction is for
		 */		
		[Bindable][VeltiInspectable]
		public var siteName:String;
		/**
		 * What page name the interaction is for 
		 */		
		[Bindable][VeltiInspectable]
		public var pageName:String;
		/**
		 * The total visitors expected for this interaction
		 */		
		[Bindable][VeltiInspectable]
		public var totalVisitors:uint;
		/**
		 * The total visits expected for this interaction
		 */		
		[Bindable][VeltiInspectable]
		public var totalVisits:uint;
		/**
		 * The type of the current element 
		 */		
		[Bindable][VeltiInspectable]
		public var type:InteractionType;
		/**
		 * @inheritDoc
		 */
		override public function get isValid():Boolean {
			return siteName != null && siteName != ""
				&& builtFrom != null && builtFrom != ""
				&& createdUsing != null && createdUsing != ""
				&& pageName != null && pageName != ""
				&& totalVisitors != 0
				&& totalVisits != 0;
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
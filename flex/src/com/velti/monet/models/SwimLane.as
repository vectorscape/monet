package com.velti.monet.models {
	
	/**
	 * Represents the information necessary to define
	 * a visual swim lane in Monet. 
	 * 
	 * @author Ian Serlin
	 */	
	public class SwimLane {
		
		// ================= Public Properties ===================
		
		/**
		 * Should be one of the <code>com.velti.monet.models.ElementType</code> types. 
		 */		
		public var type:String;
		
		/**
		 * The color to draw this lane as.
		 * 
		 * @default 0xCCCCCC 
		 */		
		public var color:uint = 0xCCCCCC;
		
		/**
		 * Whether or not the user is allowed to add elements to this lane.
		 * 
		 * @default true 
		 */
		public var editable:Boolean = true;
		
		// ================= Protected Properties ===================
		
		
		// ================= Constructor ===================
		
		/**
		 * Constructor.
		 * 
		 * @param type (optional) See type
		 * @param color (optional) See color, default 0xCCCCCC
		 * @param editable (optional) See editable, default true
		 */				
		public function SwimLane( type:String=null, color:uint=0xCCCCCC, editable:Boolean=true ) {
			super();
			this.type = type;
			this.color = color;
			this.editable = editable;
		}
		
		// ================= Event Handlers ===================
		
		// ================= Protected Utilities ===================
		
	}
}
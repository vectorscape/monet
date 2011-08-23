package com.velti.monet.models {
	
	/**
	 * Represents one element or node in the
	 * campaign graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Element {
		
		/**
		 * The type of element this instance
		 * represents, one of the valid values
		 * from <code>ElementTypes</code>.  
		 */		
		public var type:String;
		
		/**
		 * The label to display that visually
		 * describes this element.
		 */
		public function get label():String {
			return _label;
		}
		public function set label( value:String ):void {
			if( _label != value ){
				_label = value;
			}
		}
		/**
		 * @private 
		 */		
		protected var _label:String;
		
		/**
		 * Constructor 
		 */		
		public function Element( type:String, label:String=null ) {
			this.type = type;
			this.label = label;
		}
	}
}
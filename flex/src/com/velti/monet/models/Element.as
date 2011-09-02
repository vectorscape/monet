package com.velti.monet.models {
	import mx.utils.UIDUtil;
	
	/**
	 * Represents one element or node in the
	 * campaign graph.
	 * 
	 * @author Ian Serlin
	 */	
	public class Element {
		
		/**
		 * The label to display that visually
		 * describes this element.
		 */
		public function get id():String {
			return _id;
		}
		public function set id( value:String ):void {
			if( _id != value ){
				_id = value;
			}
		}
		/**
		 * @private 
		 */		
		protected var _id:String;
		
		/**
		 * The type of element this instance
		 * represents, one of the valid values
		 * from <code>ElementType</code>.  
		 */		
		public var type:ElementType;
		
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
		public function Element( type:ElementType=null, label:String=null, id:String=null ) {
			this.type 	= type;
			this.label 	= label;
			this.id 	= id && id != '' ? id : UIDUtil.createUID();
		}
	}
}
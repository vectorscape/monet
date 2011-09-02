package com.velti.monet.models {
	
	import mx.resources.ResourceManager;
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
		public function get uid():String {
			return _uid;
		}
		public function set uid( value:String ):void {
			if( _uid != value ){
				_uid = value;
			}
		}
		/**
		 * @private 
		 */		
		protected var _uid:String;
		
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
		 * Current status of this element.
		 *  
		 * @see com.velti.monet.controls.elementClasses.ElementStatus
		 */		
		public var status:ElementStatus;
		
		/**
		 * True if this element should be treated as a isTemplate element.
		 */		
		public var isTemplate:Boolean = false;
		
		/**
		 * Constructor 
		 */		
		public function Element( type:ElementType=null, label:String=null, uid:String=null, status:ElementStatus=null, isTemplate:Boolean=false ) {
			this.type 		= type;
			this.label 		= label;
			this.uid 		= uid && uid != '' ? uid : UIDUtil.createUID();
			this.status 	= status ? status : ElementStatus.INCOMPLETE;
			this.isTemplate = isTemplate;
		}
	}
}
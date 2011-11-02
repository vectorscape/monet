package com.velti.monet.models {
	
	/**
	 * Enumerable set of interaction modes for the application.
	 *  
	 * @author Ian Serlin
	 */	
	public class InteractionMode {
		
		public static const NONE:InteractionMode = new InteractionMode("none");
		public static const HAND:InteractionMode = new InteractionMode("hand");
		public static const COPY:InteractionMode = new InteractionMode("copy");
		public static const MOVE:InteractionMode = new InteractionMode("move");
		public static const SELECT_MULTIPLE:InteractionMode = new InteractionMode("selectMultiple");
		public static const MAGIC:InteractionMode = new InteractionMode("magic");
		
		/**
		 * String representation of this interaction mode. 
		 */		
		public function get name():String {
			return _name;
		}
		/**
		 * @private 
		 */		
		private var _name:String;
		
		/**
		 * Constructor 
		 */		
		public function InteractionMode(name:String = null){
			this._name = name;
		}
		
	}
}
package com.velti.monet.models {
	
	/**
	 * Enumerable set of interaction modes for the application.
	 *  
	 * @author Ian Serlin
	 */	
	public class InteractionMode {
		
		public static const MOVE:InteractionMode = new InteractionMode("move");
		public static const SELECT:InteractionMode = new InteractionMode("select");
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
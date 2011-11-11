package com.velti.monet.models.elementData
{
	/**
	 * Used to gather all ElementData properties 
	 * that are marked with a VeltiInspectable metadata tag
	 * @author Ian Serlin
	 * 
	 */
	public class DuplicatableProperty
	{
		/**
		 * The name of the property
		 */
		public var name:String;
		/**
		 * The value or the property
		 */
		public var value:String;
		
		/**
		 * Constructor
		 * @param name
		 * @param value
		 * 
		 */
		public function DuplicatableProperty(name:String = "", value:String = "") {
			this.name = name;
			this.value = value;
		}
	}
}
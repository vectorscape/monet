package com.velti.monet.models
{
	/**
	 * ICloneable is an interface used to make copies of objects.
	 * @author Clint Modien
	 * 
	 */	
	public interface ICloneable
	{
		/**
		 * Makes a copy of this object.
		 * @return The clonable object.
		 * 
		 */		
		function clone():ICloneable; // NO PMD
	}
}
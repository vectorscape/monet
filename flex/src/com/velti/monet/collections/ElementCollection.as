package com.velti.monet.collections
{
	import com.velti.monet.models.Element;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Collection class for holding sets of Elements.
	 * 
	 * @author Ian Serlin
	 */	
	public class ElementCollection extends ArrayCollection implements IElementCollection
	{
		/**
		 * Constructor
		 * @param source
		 * 
		 */		
		public function ElementCollection(source:Array=null)
		{
			super(source);
		}
		/**
		 * Adds an element 
		 * @param element
		 * @return 
		 * 
		 */		
		public function add(element:Element):Element
		{
			return super.addItem( element ) as Element;
		}
		/**
		 * Adds an element at the index specified
		 * @param element
		 * @param index
		 * @return 
		 * 
		 */		
		public function addAt(element:Element, index:int):Element
		{
			return super.addItemAt( element, index ) as Element;
		}
		/**
		 * Gets an element at the specified index 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getAt(index:int):Element
		{
			return super.getItemAt( index ) as Element;
		}
		/**
		 * Gets the index given the element specified 
		 * @param element
		 * @return 
		 * 
		 */		
		public function getIndex(element:Element):int
		{
			return super.getItemIndex( element );
		}
		/**
		 * Removes the specified element
		 * @param element
		 * @return 
		 * 
		 */		
		public function remove(element:Element):Element
		{
			return super.removeItemAt( super.getItemIndex( element ) ) as Element;
		}
		/**
		 * Removes the element at the specified index 
		 * @param index
		 * @return 
		 * 
		 */		
		public function removeAt(index:int):Element
		{
			return super.removeItemAt( index ) as Element;
		}
		/**
		 * Checks to see if this collection contains the element 
		 * @param element
		 * @return 
		 * 
		 */		
		public function containsElement(element:Element):Boolean
		{
			return super.contains( element );
		}
	}
}
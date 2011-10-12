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
		public function ElementCollection(source:Array=null)
		{
			super(source);
		}
		
		public function add(element:Element):Element
		{
			return super.addItem( element ) as Element;
		}
		
		public function addAt(element:Element, index:int):Element
		{
			return super.addItemAt( element, index ) as Element;
		}
		
		public function getAt(index:int):Element
		{
			return super.getItemAt( index ) as Element;
		}
		
		public function getIndex(element:Element):int
		{
			return super.getItemIndex( element );
		}
		
		public function remove(element:Element):Element
		{
			return super.removeItemAt( super.getItemIndex( element ) ) as Element;
		}
		
		public function removeAt(index:int):Element
		{
			return super.removeItemAt( index ) as Element;
		}
		
		public function containsElement(element:Element):Boolean
		{
			return super.contains( element );
		}
	}
}
package com.velti.monet.collections
{
	import com.velti.monet.models.Element;
	
	import flash.events.IEventDispatcher;

	/**
	 * Contract for collections of elements.
	 * 
	 * @author Ian Serlin
	 */	
	public interface IElementCollection extends IEventDispatcher
	{
		function add( element:Element ):Element;
		function addAt( element:Element, index:int ):Element;
		function getAt( index:int ):Element;
		function getIndex( element:Element ):int;
		function remove( element:Element ):Element;
		function removeAt( index:int ):Element;
		function removeAll():void;
		
		
		function containsElement( element:Element ):Boolean;
		
		function get length():int;
		
		function refresh():Boolean;
		function toArray():Array;
		
		function get source():Array;
		function set source( value:Array ):void;
	}
}
package com.velti.monet.collections
{
	import com.velti.monet.models.Publisher;

	public interface IPublisherCollection extends ICollection
	{
		function concat(publishers:Vector.<Publisher>):Vector.<Publisher>;
		function replace(publishers:Vector.<Publisher>):Vector.<Publisher>;
		
		function add(publisher:Publisher):Publisher; 
		function addAt(publisher:Publisher, index:int):Publisher;
		
		function remove(publisher:Publisher):Publisher;
		function removeAt(index:int):Publisher;
		
		function getAt(index:int):Publisher;
		function getIndex(publisher:Publisher):int;
		
		function setAt(publisher:Publisher, index:int):Publisher;
		
		function find(property:String,value:Object):Vector.<Publisher>
	}
}
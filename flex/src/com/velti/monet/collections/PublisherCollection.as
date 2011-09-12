package com.velti.monet.collections 
{
	import com.velti.monet.models.Publisher;
	import com.velti.vectorToArray;
	
	import mx.collections.ArrayList;
	import mx.collections.ArrayCollection;
	
	public class PublisherCollection extends ArrayCollection implements IPublisherCollection 
	{
		public function concat(items:Vector.<Publisher>):Vector.<Publisher> {
			super.addAll(new ArrayList(vectorToArray(items)));
			return items;
		}
		
		public function replace(items:Vector.<Publisher>):Vector.<Publisher> {
			var returnVal:Vector.<Publisher> = Vector.<Publisher>(super.source);
			super.source = vectorToArray(items);
			return returnVal;
		}
		
		public function PublisherCollection(source:Array=null) {
			super(source);
		}
		
		public function add(publisher:Publisher):Publisher {
			super.addItem(publisher)
			return publisher;
		}
		
		public function addAt(publisher:Publisher, index:int):Publisher {
			super.addItemAt(publisher,index)
			return publisher;
		}
		
		public function remove(publisher:Publisher):Publisher {
			return super.removeItemAt(super.getItemIndex(publisher)) as Publisher;
		}
		
		public function removeAt(index:int):Publisher {
			return super.removeItemAt(index) as Publisher;
		}
		
		public function getAt(index:int):Publisher {
			return super.getItemAt(index) as Publisher;
		}
		
		public function getIndex(publisher:Publisher):int {
			return super.getItemIndex(publisher);
		}
		
		public function setAt(publisher:Publisher, index:int):Publisher {
			return super.setItemAt(publisher,index) as Publisher;
		}
		
		public function find(property:String,value:Object):Vector.<Publisher> {
			var returnVal:Vector.<Publisher> = new Vector.<Publisher>();
			for each (var item:Publisher in this) {
				if(item[property] == value) returnVal.push(item);
			}
			return returnVal;
		}
	}
}
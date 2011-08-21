package com.velti.monet.controls.nodeClasses
{
	public class NodeStatus
	{
		public static const COMPLETE:NodeStatus = new NodeStatus("complete");
		public static const INCOMPLETE:NodeStatus = new NodeStatus("incomplete");
		
		public var value:String;
		public var color:uint;
		
		public function NodeStatus(value:String) {
			this.value = value;
		}
	}
}
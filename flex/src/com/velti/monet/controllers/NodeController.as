package com.velti.monet.controllers
{
	import com.velti.monet.controls.Node;
	
	import flash.events.MouseEvent;

	public class NodeController
	{
		[ViewAdded]
		public function appAdded(monet:Monet):void {
			monet.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false,0,true);
		}

		private function onDoubleClick(event:MouseEvent):void {
			if(event.target is Node) {
				trace("double clicked a node");
			}
		}
	}
}
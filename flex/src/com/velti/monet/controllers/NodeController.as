package com.velti.monet.controllers
{
	import com.velti.monet.controls.Node;
	import com.velti.monet.controls.nodeClasses.NodeType;
	import com.velti.monet.views.nodeEditors.AudienceEditView;
	import com.velti.monet.views.nodeEditors.ContentEditView;
	import com.velti.monet.views.nodeEditors.InteractionEditView;
	import com.velti.monet.views.nodeEditors.PlanEditView;
	import com.velti.monet.views.nodeEditors.PublisherPlacementEditView;
	
	import flash.events.MouseEvent;
	
	/**
	 * Handles node interaction.
	 * @author Clint Modien
	 * 
	 */	
	public class NodeController
	{
		/**
		 * Handler for when the app gets added to the stage
		 */		
		[ViewAdded]
		public function appAdded(monet:Monet):void {
			monet.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false,0,true);
		}

		private function onDoubleClick(event:MouseEvent):void {
			if(event.target is Node) {
				const node:Node = event.target as Node;
				trace("handling node type " + node.type);
				switch (node.type) {
					case NodeType.PLAN :
						new PlanEditView().show();
						break;
					case NodeType.AUDIENCE :
						new AudienceEditView().show();
						break;
					case NodeType.PUBLISHER :
						new PublisherPlacementEditView().show();
						break;
					case NodeType.PLACEMENT :
						new PublisherPlacementEditView().show();
						break;
					case NodeType.CONTENT :
						new ContentEditView().show();
						break;
					case NodeType.INTERACTION :
						new InteractionEditView().show();
						break;
					default :
						trace("node type not found: " + node.type.name)
				}
			}
		}
	}
}
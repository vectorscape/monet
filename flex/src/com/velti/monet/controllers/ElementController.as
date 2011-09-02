package com.velti.monet.controllers
{
	import com.velti.monet.controls.ElementRenderer;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.views.elementEditors.AudienceEditView;
	import com.velti.monet.views.elementEditors.ContentEditView;
	import com.velti.monet.views.elementEditors.InteractionEditView;
	import com.velti.monet.views.elementEditors.PlanEditView;
	import com.velti.monet.views.elementEditors.PublisherPlacementEditView;
	
	import flash.events.MouseEvent;
	
	/**
	 * Handles node interaction.
	 * @author Clint Modien
	 * 
	 */	
	public class ElementController
	{
		/**
		 * Handler for when the app gets added to the stage
		 */		
		[ViewAdded]
		public function appAdded(monet:Monet):void {
			monet.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false,0,true);
		}

		private function onDoubleClick(event:MouseEvent):void {
			if(event.target is ElementRenderer) {
				const node:ElementRenderer = event.target as ElementRenderer;
				trace("handling node type " + node.type);
				switch (node.type) {
					case ElementType.CAMPAIGN :
						new PlanEditView().show();
						break;
					case ElementType.AUDIENCE :
						new AudienceEditView().show();
						break;
					case ElementType.PUBLISHER :
						new PublisherPlacementEditView().show();
						break;
					case ElementType.PLACEMENT :
						new PublisherPlacementEditView().show();
						break;
					case ElementType.CONTENT :
						new ContentEditView().show();
						break;
					case ElementType.INTERACTION :
						new InteractionEditView().show();
						break;
					default :
						trace("node type not found: " + node.type.name)
				}
			}
		}
	}
}
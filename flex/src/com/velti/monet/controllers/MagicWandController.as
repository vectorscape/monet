package com.velti.monet.controllers
{
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.events.MagicWandEvent;
	import com.velti.monet.models.InteractionMode;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.models.elementData.VeltiInspectableProperty;
	import com.velti.monet.views.Cursors;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.managers.CursorManager;
	
	import org.hamcrest.text.containsString;

	public class MagicWandController
	{
		[Inject]
		public var presoModel:PresentationModel;
		
		[EventHandler(event="MagicWandEvent.TOOL_CHOSEN")]
		public function magicWand_toolChosen():void {
			presoModel.wandedElement = null;
		}
		
		[EventHandler(event="MagicWandEvent.FIRST_SELECTED")]
		public function magicWandFirstSelected(event:MagicWandEvent):void {
			presoModel.wandedElement = event.element;
		}
		
		[EventHandler(event="MagicWandEvent.SUBSEQUENT_SELECTED")]
		public function magicWandSubsequentSelected(e:MagicWandEvent):void {
			if(canCopy) {
				var propsList:Array = presoModel.wandedElement.data.propertyList;
				for each (var prop:VeltiInspectableProperty in propsList) {
					try {
						e.element.data[prop.name] = presoModel.wandedElement.data[prop.name];
					} catch (err:ReferenceError) {
						if(err.message.indexOf("read-only") == -1)
							throw(err);
					}
				}
			}
		}
		
		private var canCopy:Boolean = false;
		
		[EventHandler(event="ElementEvent.HOVERED")]
		public function elementRenderer_hovered(e:ElementEvent):void {
			if(presoModel.interactionMode == InteractionMode.MAGIC && presoModel.wandedElement) {
				CursorManager.removeAllCursors();
				if(presoModel.wandedElement.type != e.element.type) {
					canCopy = false;
					CursorManager.setCursor(Cursors.MAGIC_WAND_NO_COPY);
				} else if (presoModel.wandedElement != e.element) {
					canCopy = true;
					CursorManager.setCursor(Cursors.MAGIC_WAND);
				}
			}
		}
		
		[EventHandler(event="ElementEvent.UNHOVERED")]
		public function elementRenderer_unhovered(e:ElementEvent):void {
			if(presoModel.interactionMode == InteractionMode.MAGIC) {
				CursorManager.removeAllCursors();
				CursorManager.setCursor(Cursors.MAGIC_WAND);
				canCopy = false;
			}
		}
		
		[EventHandler("InteractionModeEvent.CHANGE",properties="interactionMode")]
		public function interactionMode_change( interactionMode:InteractionMode ):void {
			if(interactionMode != InteractionMode.MAGIC) {
				presoModel.wandedElement = null;
			}
		}
	}
}
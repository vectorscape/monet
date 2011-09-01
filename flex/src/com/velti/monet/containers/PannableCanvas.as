package com.velti.monet.containers {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;

	/**
	 * Canvas extension which allows click and drag
	 * panning of the scrollable view.
	 * 
	 * @author Clint Modien
	 */	
	public class PannableCanvas extends Canvas {
		
		// ================= Public Properties ===================
		
		/**
		 * Whether or not the control is currently panning
		 */
		public var isPanning:Boolean;
		/**
		 * Whether or not the control is able to pan
		 */
		public var pannable:Boolean = true;
		
		// ================= Protected Properties ===================
		
		/**
		 * The last pan point between mouse movements.
		 */
		private var prevPanPoint:Point = new Point();
		
		// ================= Constructor ===================
		
		/**
		 * Constructor 
		 */		
		public function PannableCanvas() {
			this.addEventListener( MouseEvent.MOUSE_DOWN, this_mouseDownHandler );
		}
		
		// ================= Event Handlers ===================
		
		private function this_mouseDownHandler(event:MouseEvent):void {
			if(pannable){
				startPanning(event);
			}
		}
		
		private function systemManager_mouseMoveHandler(event:MouseEvent):void {
			event.stopImmediatePropagation();
			this.verticalScrollPosition -= event.stageY - prevPanPoint.y;
			this.horizontalScrollPosition -= event.stageX - prevPanPoint.x;
			prevPanPoint.x = event.stageX;
			prevPanPoint.y = event.stageY;
		}
		
		private function systemManager_mouseUpHandler(event:MouseEvent):void {
			if (isPanning){
				stopPanning();
			}
		}
		
		private function stage_mouseLeaveHandler(event:Event):void {
			if (isPanning){
				stopPanning();
			}
		}
		
		// ================= Protected Utilities ===================
		
		/**
		 * Causes the diagram to start panning
		 */
		protected function startPanning(event:MouseEvent):void {
			prevPanPoint.x = event.stageX;
			prevPanPoint.y = event.stageY;
			systemManager.addEventListener(
				MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
			systemManager.addEventListener(
				MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			systemManager.stage.addEventListener(
				Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
			isPanning = true;
		}
		private function stopPanning():void {
			systemManager.removeEventListener(
				MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
			systemManager.removeEventListener(
				MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
			systemManager.stage.removeEventListener(
				Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
		}
	}
}
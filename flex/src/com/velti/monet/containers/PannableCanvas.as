package com.velti.monet.containers {
	import com.velti.monet.models.DiagramScrollModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;

	/**
	 * Canvas extension which allows click and drag
	 * panning of the scrollable view.
	 * 
	 * @author Clint Modien
	 */	
	public class PannableCanvas extends Canvas {
		
		// ================= Public Properties ===================
		
		/**
		 * Handle to the model we use to expose
		 * our scroll properties. 
		 */		
		[Inject]
		public var scrollModel:DiagramScrollModel;
		
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
			this.addEventListener( MouseEvent.MOUSE_DOWN, this_mouseDown );
			this.addEventListener( ResizeEvent.RESIZE, this_resize );
			this.addEventListener( ScrollEvent.SCROLL, this_scroll );
			this.addEventListener( FlexEvent.CREATION_COMPLETE, this_creationComplete );
		}
		
		// ================= Public Methods ===================
		
		/**
		 * Force an update to the scroll model right now.
		 * 
		 * @return true if the model could be updated 
		 */		
		[PostConstruct]
		public function forceUpdateScrollModel():Boolean {
			return updateScrollModel();
		}
		
		// ================= Event Handlers ===================
		
		/**
		 * Handles this canvas finishing being created. 
		 */		
		protected function this_creationComplete( event:FlexEvent ):void {
			updateScrollModel();
		}
		
		/**
		 * Handles this canvas resizing. 
		 */		
		protected function this_resize( event:ResizeEvent ):void {
			updateScrollModel();
		}
		
		/**
		 * Handles this canvas scrolling. 
		 */		
		protected function this_scroll( event:ScrollEvent ):void {
			updateScrollModel();
		}
		
		protected function this_mouseDown(event:MouseEvent):void {
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
		 * Updates the attached scroll model with our properties,
		 * if available. 
		 * 
		 * @return true if the model could be updated
		 */		
		protected function updateScrollModel():Boolean {
			var success:Boolean = false;
			if( scrollModel ){
				scrollModel.diagramWidth = this.width;
				scrollModel.diagramHeight = this.height;
				scrollModel.scrollX = this.horizontalScrollPosition;
				scrollModel.scrollY = this.verticalScrollPosition;
				success = true;
			}
			return success;
		}
		
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
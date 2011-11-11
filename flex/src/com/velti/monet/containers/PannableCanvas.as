package com.velti.monet.containers {
	import com.velti.monet.models.DiagramScrollModel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;
	import mx.graphics.ImageSnapshot;

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
		protected var prevPanPoint:Point = new Point();
		
		// ================= Constructor ===================
		
		/**
		 * Constructor 
		 */		
		public function PannableCanvas() {
			this.addEventListener( MouseEvent.MOUSE_DOWN, this_mouseDown );
			this.addEventListener( ResizeEvent.RESIZE, this_resize );
			this.addEventListener( ScrollEvent.SCROLL, this_scroll );
			this.addEventListener( FlexEvent.CREATION_COMPLETE, this_creationComplete );
			this.addEventListener( FlexEvent.UPDATE_COMPLETE, this_updateComplete );
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
		 * Handles this canvas finishing an flex lifecycle loop. 
		 */		
		protected function this_updateComplete( event:FlexEvent ):void {
			updateScrollModel();
		}

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
			updatePanPosition(event);
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
		 * Updates the pan position given the passed in mouse event. 
		 */		
		protected function updatePanPosition(event:MouseEvent):void {
			this.verticalScrollPosition -= event.stageY - prevPanPoint.y;
			this.horizontalScrollPosition -= event.stageX - prevPanPoint.x;
			prevPanPoint.x = event.stageX;
			prevPanPoint.y = event.stageY;
			updateScrollModel();
		}
		
		/**
		 * Updates the attached scroll model with our properties,
		 * if available. 
		 * 
		 * @return true if the model could be updated
		 */		
		protected function updateScrollModel():Boolean {
			var success:Boolean = false;
			if( scrollModel ){
				scrollModel.viewportWidth = this.width;
				scrollModel.viewportHeight = this.height;
				scrollModel.scrollX = this.horizontalScrollPosition > 0 ? this.horizontalScrollPosition : 0;
				scrollModel.scrollY = this.verticalScrollPosition > 0 ? this.verticalScrollPosition : 0;
				scrollModel.maxScrollX = this.maxHorizontalScrollPosition; // can't be trusted?
				scrollModel.maxScrollY = this.maxVerticalScrollPosition; // can't be trusted?
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
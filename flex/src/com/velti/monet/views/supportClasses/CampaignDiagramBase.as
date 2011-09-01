package com.velti.monet.views.supportClasses {
	import com.velti.monet.containers.PannableCanvas;
	
	import mx.collections.IList;
	
	/**
	 * Implements the base functionality of the Campaign Diagram view.
	 * 
	 * @author Ian Serlin
	 */	
	public class CampaignDiagramBase extends PannableCanvas {
		
		// ================= Public Properties ===================

		/**
		 * @private 
		 */		
		private var _dataProvider:IList;

		/**
		 * The elements this diagram is displaying, should only contain
		 * <code>com.velti.monet.models.Element</code> instances. 
		 */
		public function get dataProvider():IList {
			return _dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:IList):void {
			if( value != _dataProvider ){
				_dataProvider = value;
				_dataProviderChanged = true;
				this.invalidateProperties();
			}
		}

		/**
		 * @private 
		 */		
		private var _drawSwimLanes:Boolean = false;
		
		/**
		 * Determines whether or not to draw the "swim-lane"
		 * dividers in the background of this view.
		 */
		public function get drawSwimLanes():Boolean {
			return _drawSwimLanes;
		}
		
		/**
		 * @private
		 */
		public function set drawSwimLanes(value:Boolean):void {
			if( value != _drawSwimLanes ){
				_drawSwimLanes = value;
				_drawSwimLanesChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>drawSwimLanes</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _drawSwimLanesChanged:Boolean = false;
		
		// ================= Protected Properties ===================
		
		/**
		 * True if the value of <code>dataProvider</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _dataProviderChanged:Boolean = false;
		
		// ================= Constructor ===================
		
		/**
		 * Constructor. 
		 */		
		public function CampaignDiagramBase() {
			super();
		}
		
		// ================= Event Handlers ===================
		
		// ================= Protected Utilities ===================
		
		// ================= Overriden Methods ===================
		
		/**
		 * @inheritDoc 
		 */		
		override protected function commitProperties():void {
			super.commitProperties();
			
			// Handles the data provider backing this view being updated.
			if( _dataProviderChanged ){
				_dataProviderChanged = false;
			}
			
			// Handles the option to draw swim lanes being toggled.
			if( _drawSwimLanesChanged ){
				this.invalidateDisplayList();
				_drawSwimLanesChanged = false;
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			
		}
		
	}
}
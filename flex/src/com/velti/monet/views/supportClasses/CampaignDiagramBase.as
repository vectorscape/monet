package com.velti.monet.views.supportClasses {
	import com.velti.monet.containers.PannableCanvas;
	import com.velti.monet.models.SwimLane;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import mx.collections.IList;
	import mx.controls.Label;
	
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
		 * True if the value of <code>dataProvider</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _dataProviderChanged:Boolean = false;
		
		/**
		 * @private 
		 */		
		private var _showSwimLanes:Boolean = false;
		
		/**
		 * Determines whether or not to draw the "swim-lane"
		 * dividers in the background of this view.
		 */
		public function get showSwimLanes():Boolean {
			return _showSwimLanes;
		}
		
		/**
		 * @private
		 */
		public function set showSwimLanes(value:Boolean):void {
			if( value != _showSwimLanes ){
				_showSwimLanes = value;
				_showSwimLanesChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>showSwimLanes</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _showSwimLanesChanged:Boolean = false;
		
		/**
		 * @private 
		 */		
		private var _swimLanes:IList;
		
		/**
		 * The collection of swim lanes to draw, if any.
		 * Should be instances of <code>com.velti.monet.models.SwimLane</code>.
		 */
		public function get swimLanes():IList {
			return _swimLanes;
		}
		
		/**
		 * @private
		 */
		public function set swimLanes(value:IList):void {
			if( value != _swimLanes ){
				_swimLanes = value;
				_swimLanesChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>swimLanes</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _swimLanesChanged:Boolean = false;
		
		// ================= Protected Properties ===================
		
		/**
		 * True if the swim lanes need to be re-drawn on the screen. 
		 */		
		protected var _swimLanesStale:Boolean = false;
		
		/**
		 * Array that keeps references to the swim lane labels. 
		 */		
		protected var _swimLaneLabels:Array;
		
		// ================= Constructor ===================
		
		/**
		 * Constructor. 
		 */		
		public function CampaignDiagramBase() {
			super();
		}
		
		// ================= Event Handlers ===================
		
		// ================= Protected Utilities ===================
		
		/**
		 * Renders out the swim lane definitions to the screen.
		 */		
		protected function drawSwimLanes( unscaledWidth:Number, unscaledHeight:Number ):void {
			var g:Graphics = this.graphics;
			g.clear();
			
			var numberOfLanes:Number = swimLanes ? swimLanes.length : 0;
			if( numberOfLanes < 1 ){ return; }
			
			// reset the labels, if any
			var label:Label;
			if( _swimLaneLabels ){
				while( _swimLaneLabels.length > numberOfLanes ){
					label = _swimLaneLabels.pop();
					if( this.contains( label ) ){
						this.removeChild( label );
					}
				}
			}else{
				_swimLaneLabels = [];
			}
			
			var laneWidth:Number = unscaledWidth / numberOfLanes;
			var swimLane:SwimLane;
			
			var colors:Array; 
			var alphas:Array = [1, 1]; 
			var ratios:Array = [0, 255]; 
			var matrix:Matrix = new Matrix(); 
			var horizontalOffset:Number;
			
			// for each swim lane
			for( var i:int = 0; i < numberOfLanes; i++ ){
				// 1. draw the gradient background
				swimLane = swimLanes.getItemAt( i ) as SwimLane;
				horizontalOffset = i * laneWidth;
				matrix.createGradientBox( laneWidth, unscaledHeight, 90, horizontalOffset, 0 );
				colors = [ swimLane.color, swimLane.color ];
				g.beginGradientFill( GradientType.LINEAR, colors, [1,1], [0,255], matrix );
				g.drawRect( horizontalOffset, 0, laneWidth, unscaledHeight );
				g.endFill();
				// 2. draw the dividing lie
				g.lineStyle( 1, 0x000000 );
				g.moveTo( horizontalOffset, 0 );
				g.lineTo( horizontalOffset, unscaledHeight );
				// 3. create and position the label
				if( _swimLaneLabels.length <= i ){
					_swimLaneLabels.push( new Label() );
				}
				label 		= _swimLaneLabels[ i ] as Label;
				label.text 	= swimLane.type ? swimLane.type.toUpperCase() : 'Level ' + i;
				label.width = laneWidth;
				label.x 	= horizontalOffset;
				label.y 	= 10;
				label.setStyle( 'textAlign', 'center' );				
				this.addChild( label );
			}
		}
		
		/**
		 * Removes all swim lanes from the display.
		 */		
		protected function clearSwimLanes():void {
			graphics.clear();
			var label:Label;
			for each( label in _swimLaneLabels ){
				if( this.contains( label ) ){
					this.removeChild( label );
				}
			}
			_swimLaneLabels = [];
		}
		
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
			if( _showSwimLanesChanged || _swimLanesChanged ){
				_showSwimLanesChanged = _swimLanesChanged = false;
				
				this.invalidateDisplayList();
				_swimLanesStale = true;
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// re-draws the swim lanes
			if( _swimLanesStale ){
				_swimLanesStale = false;
				if( showSwimLanes ){
					drawSwimLanes( unscaledWidth, unscaledHeight );
				}else{
					clearSwimLanes();
				}
			}
		}
		
	}
}
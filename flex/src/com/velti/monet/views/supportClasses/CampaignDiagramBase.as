package com.velti.monet.views.supportClasses {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.containers.PannableCanvas;
	import com.velti.monet.controls.ElementRenderer;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.SwimLane;
	
	import flash.display.DisplayObject;
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
		private var _elements:IndexedCollection;
		
		/**
		 * The set of unique elements that make up the campaign to be drawn.
		 */
		public function get elements():IndexedCollection {
			return _elements;
		}
		
		/**
		 * @private
		 */
		public function set elements(value:IndexedCollection):void {
			if( value != _elements ){
				_elements = value;
				_elementsChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>elements</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _elementsChanged:Boolean = false;
		
		/**
		 * @private 
		 */		
		private var _elementRenderer:Class;
		
		/**
		 * The <code>com.velti.monet.views.supportClasses.IElementRenderer</code>
		 * to use to visually represent the elements in this diagram on screen.
		 */
		public function get elementRenderer():Class {
			return _elementRenderer;
		}
		
		/**
		 * @private
		 */
		public function set elementRenderer(value:Class):void {
			if( value != _elementRenderer ){
				_elementRenderer = value;
				_elementRendererChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>elementRenderer</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _elementRendererChanged:Boolean = false;
		
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
		
		/**
		 * The collection of visual nodes that are being placed on the display list. 
		 */		
		protected var _renderers:IndexedCollection;
		
		/**
		 * True if the nodes need to be re-drawn on the screen. 
		 */		
		protected var _renderersStale:Boolean = false;
		
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
		
		/**
		 * Makes sure the number of nodes and elements that this
		 * diagram is maintaining match and that the  
		 */		
		protected function generateRenderers():void {
			if( _renderers == null ){
				_renderers = new IndexedCollection("elementID");
			}
			var element:Element;
			var renderer:IElementRenderer;
			
			// 1. remove renderers that are no longer valid
			var renderersToBeRemoved:Array = [];
			for each( renderer in _renderers ){
				if( elements.getItemByIndex( renderer.elementID ) == null ){
					renderersToBeRemoved.push( renderer );
				}
			}
			// TODO: can we just remove them directly in the loop above
			// or will that confuse the loop?
			for each( renderer in renderersToBeRemoved ){
				if( this.contains( renderer as DisplayObject ) ){
					this.removeChild( renderer as DisplayObject );
				}
				_renderers.removeItemByIndex( renderer.elementID );
			}
			
			// 2. create renderers for elements which do not already have one
			for each( element in elements ){
				if( _renderers.getItemByIndex( element.id ) == null ){
					renderer = new elementRenderer() as IElementRenderer;
					renderer.element = element;
					_renderers.addItem( renderer );
					renderer.x = 10;
					renderer.y = 10
					this.addChild( renderer as DisplayObject );
				}
			}
			trace( "CampaignDiagramBase::generateRenderers > Total generated renderers: " + _renderers.length );
		}
		
		/**
		 * Removes all visual nodes from screen and memory. 
		 */		
		protected function clearRenderers():void {
			for each( var renderer:IElementRenderer in _renderers ){
				if( this.contains( renderer as DisplayObject ) ){
					this.removeChild( renderer as DisplayObject );
				}
			}
			_renderers = null;
			trace( "CampaignDiagramBase::clearRenderers > Cleared all renderers." );
		}
		
		// ================= Overriden Methods ===================
		
		/**
		 * @inheritDoc 
		 */		
		override protected function commitProperties():void {
			super.commitProperties();
			
			// If the element renderer class is reset we must force reset all renderers.
			if( _elementRendererChanged ){
				_elementRendererChanged = false;
				clearRenderers();
				// force regeneration of renderers
				_elementsChanged = true;
			}
			
			// Handles the elements hash backing this view being updated.
			if( _elementsChanged ){
				_elementsChanged = false;
				if( elements ){
					if(	elements.indexedProperty != "id" ){
						elements.indexedProperty = "id";
					}
					generateRenderers();
					this.invalidateDisplayList();
					_renderersStale = true;
				}else{
					clearRenderers();
				}
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
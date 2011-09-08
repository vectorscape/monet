package com.velti.monet.views.supportClasses {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.containers.PannableCanvas;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.Map;
	import com.velti.monet.models.SwimLane;
	import com.velti.monet.utils.DrawingUtil;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.IList;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
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
				if( _elements ){
					_elements.removeEventListener(CollectionEvent.COLLECTION_CHANGE,elements_collectionChange);
				}
				_elements = value;
				if( _elements ){
					_elements.addEventListener(CollectionEvent.COLLECTION_CHANGE,elements_collectionChange);
				}
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
		private var _map:Map;
		
		/**
		 * The Map that defines the connections between this
		 * campaign's elements.
		 * 
		 * @see com.velti.monet.models.Map
		 */
		public function get map():Map {
			return _map;
		}
		
		/**
		 * @private
		 */
		public function set map(value:Map):void {
			if( value != _map ){
				_map = value;
				_mapChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>map</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _mapChanged:Boolean = false;
		
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
		
		/**
		 * @private 
		 */		
		private var _angledConnections:Boolean;
		
		/**
		 * True if you want to display connections between
		 * nodes as angles, false if you want to draw lines directly.
		 */
		public function get angledConnections():Boolean {
			return _angledConnections;
		}
		
		/**
		 * @private
		 */
		public function set angledConnections(value:Boolean):void {
			if( value != _angledConnections ){
				_angledConnections = value;
				_angledConnectionsChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>angledConnections</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _angledConnectionsChanged:Boolean = false;
		
		// ================= Protected Properties ===================
		
		/**
		 * True if the connection arrows need to be re-drawn on the screen. 
		 */		
		protected var _connectionsStale:Boolean = false;
		
		/**
		 * The sprite we draw the connection arrows onto. 
		 */		
		protected var _connectionSprite:UIComponent;
		
		/**
		 * True if the swim lanes need to be re-drawn on the screen. 
		 */		
		protected var _swimLanesStale:Boolean = false;
		
		/**
		 * Array that keeps references to the swim lane labels. 
		 */		
		protected var _swimLaneLabels:Array;
		
		/**
		 * The sprite we draw the swim lanes onto. 
		 */		
		protected var _swimLanesSprite:UIComponent;
		
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
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
		}
		
		// ================= Event Handlers ===================
		
		/**
		 * Sets up the rest of the default event listeners for this component. 
		 */		
		protected function this_addedToStage( e:Event ):void {
			addEventListener(DragEvent.DRAG_ENTER, this_dragEnter);
			addEventListener(DragEvent.DRAG_DROP, this_dragDrop);
		}
		
		/**
		 * Cleans up the default event listeners for this component. 
		 */		
		protected function this_removedFromStage( e:Event ):void {
			removeEventListener(DragEvent.DRAG_ENTER, this_dragEnter);
			removeEventListener(DragEvent.DRAG_DROP, this_dragDrop);
		}
		
		/**
		 * Called when the user moves the drag proxy onto the drop target. 
		 */		
		protected function this_dragEnter(event:DragEvent):void {
			trace( 'drag enter' );
			// Accept the drag only if the user is dragging data 
			// identified by the 'element' format value.
			if( event.dragSource.hasFormat('element') ){
				// Accept the drop.
				DragManager.acceptDragDrop(this);
			}
		}
		
		/**
		 * Called if the target accepts the dragged object and the user
		 * releases the mouse button while over the CampaignDiagramBase container.
		 */		
		protected function this_dragDrop(event:DragEvent):void {
			trace( 'drag drop' );
			
			// Get the data identified by the color format 
			// from the drag source.
			var droppedElement:Element = event.dragSource.dataForFormat( 'element' ) as Element;
			// TODO: this needs to handle dropping the same element in multiple places?
			if( droppedElement ){
				if( droppedElement.isTemplate ){
					var newElement:Element = new Element( droppedElement.type );
					elements.addItem( newElement );
					trace( 'added new element of type: ' + newElement.type.name );
					addElementToMap( newElement, event.localX, event.localY );
				}
			}
		}    
		
		/**
		 * Handles the elements collection being modified.
		 */		
		protected function elements_collectionChange( e:CollectionEvent ):void {
			_elementsChanged = true;
			this.invalidateProperties();
		}
		
		// ================= Protected Utilities ===================
		
		/**
		 * Renders out the swim lane definitions to the screen.
		 */		
		protected function drawSwimLanes( unscaledWidth:Number, unscaledHeight:Number ):void {
			var g:Graphics = _swimLanesSprite.graphics;
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
			_swimLanesSprite.graphics.clear();
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
				_renderers = new IndexedCollection("elementUID");
			}
			var element:Element;
			var renderer:IElementRenderer;
			
			// 1. remove renderers that are no longer valid
			var renderersToBeRemoved:Array = [];
			for each( renderer in _renderers ){
				if( elements.getItemByIndex( renderer.elementUID ) == null ){
					renderersToBeRemoved.push( renderer );
				}
			}
			// TODO: can we just remove them directly in the loop above
			// or will that confuse the loop?
			for each( renderer in renderersToBeRemoved ){
				if( this.contains( renderer as DisplayObject ) ){
					this.removeChild( renderer as DisplayObject );
				}
				_renderers.removeItemByIndex( renderer.elementUID );
			}
			
			// 2. create renderers for elements which do not already have one
			for each( element in elements ){
				if( _renderers.getItemByIndex( element.nodeID ) == null ){
					renderer = new elementRenderer() as IElementRenderer;
					renderer.element = element;
					_renderers.addItem( renderer );
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
		
		/**
	 	 * Updates the various layout based properties. 
		 */		
		protected function updateMappings():void {
			trace( 'CampaignDiagramBase::updateMappings > laying out ' + _renderers.length + ' renderers.' );
			layoutRenderer( map, 1, 0 );
		}
		
		/**
		 * Vertically and horizontally positions a renderer on
		 * the display list according to the given parameters.
		 * 
		 * @param mapNode
		 * @param breadth
		 * @param depth
		 */		
		protected function layoutRenderer( mapNode:Map, breadth:int, depth:int ):void {
			var renderer:IElementRenderer = _renderers.getItemByIndex( mapNode.key ) as IElementRenderer;
			var horizontalSpacing:Number = this.width / 6;
			var verticalSpacing:Number = 125; 
			if( renderer ){
				renderer.x = ( depth * horizontalSpacing ) + (renderer.width / 2);
				renderer.y = ( breadth * verticalSpacing ) + (renderer.height / 2);
			}
			trace( 'Set renderer ' + renderer.elementUID + ' to ' + renderer.x + 'x' + renderer.y );
			if( mapNode.nodes ){
				for( var i:int = 0; i < mapNode.nodes.length; i++ ){
					layoutRenderer( mapNode.nodes[i], breadth + i, depth + 1 );
				}
			}
		}
		
		/**
		 * Draws the arrows between elements in this diagram.
		 */		
		protected function drawConnections( unscaledWidth:Number, unscaledHeight:Number ):void {
			_connectionSprite.width = unscaledWidth;
			_connectionSprite.height = unscaledHeight;
			
			_connectionSprite.graphics.clear();
			_connectionSprite.graphics.lineStyle( 2 );
			
			// traverse the map, drawing lines
			_drawConnections( map, _connectionSprite.graphics );
		}
		
		/**
		 * Attempts to draw an arrow between a map and its nodes recursively.
		 * 
		 * @param map the map whose connections you want to draw
		 * @param g the graphics instance you want to draw with
		 */		
		protected function _drawConnections( map:Map, g:Graphics ):void {
			if( map && map.nodes && g ){
				var rootRenderer:IElementRenderer = _renderers.getItemByIndex( map.key ) as IElementRenderer;
				var targetRenderer:IElementRenderer;
				var startPoint:Point 	= new Point();
				var endPoint:Point 		= new Point();
				
				if( rootRenderer ){
					for each( var childMap:Map in map.nodes ){
						targetRenderer 	= _renderers.getItemByIndex( childMap.key ) as IElementRenderer;
						startPoint.x 	= rootRenderer.x + ( rootRenderer.width / 2 );
						startPoint.y 	= rootRenderer.y + ( rootRenderer.height / 2 );
						endPoint.x 		= targetRenderer.x + ( targetRenderer.width / 2 );
						endPoint.y 		= targetRenderer.y + ( targetRenderer.height / 2 );
						if( angledConnections ){
							DrawingUtil.drawRightAngleLine( startPoint, endPoint, g, 0.7 );
						}else{
							DrawingUtil.drawStraightLine( startPoint, endPoint, g );
						}
						_drawConnections( childMap, g );
					}
				}
			}
		}
		
		/**
		 * Attempts to add a newly created element to the proper place in the diagram's existing map.
		 * 
		 * @param element
		 * @param targetX
		 * @param targetY
		 */		
		protected function addElementToMap( element:Element, targetX:Number, targetY:Number ):void {
			_addElementToMap( element, map );
			_mapChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * Recursively calls itself doing a depth-first search on the given
		 * map to insert the given element at the level which contains elements
		 * of the same type.
		 * 
		 * TODO: This might make more sense to be part of Map depending on how
		 * complex this logic gets.
		 * 
		 * @param element the element you want to insert
		 * @param map the map you want to insert the element into
		 * 
		 * @return true if the element should be inserted at this level
		 */		
		protected function _addElementToMap( element:Element, map:Map ):Boolean {
			var levelType:ElementType = (elements.getItemByIndex( map.key ) as Element).type;
			if( levelType == element.type ){
				return true;
			}else{
				for each( var mapNode:Map in map.nodes ){
					if( mapNode && _addElementToMap( element, mapNode ) ){
						var newMap:Map = new Map();
						newMap.key = element.nodeID;
						map.nodes.push( newMap );
						break;
					}
				}
			}
			return false;
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
				_connectionsStale = true;
				this.invalidateDisplayList();
			}
			
			// Handles the elements hash backing this view being updated.
			if( _elementsChanged ){
				_elementsChanged = false;
				if( elements ){
					if(	elements.indexedProperty != "uid" ){
						elements.indexedProperty = "uid";
					}
					generateRenderers();
					_renderersStale = true;
					_connectionsStale = true;
					this.invalidateDisplayList();
				}else{
					clearRenderers();
				}
			}
			
			// Handles the option to draw swim lanes being toggled.
			if( _showSwimLanesChanged || _swimLanesChanged ){
				_showSwimLanesChanged = _swimLanesChanged = false;
				
				_swimLanesStale = true;
				this.invalidateDisplayList();
			}
			
			// Handles the option to draw angled connecting lines being toggled.
			if( _angledConnectionsChanged ){
				_angledConnectionsChanged = false;
				_connectionsStale = true;
				this.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Handles the map describing the diagram being updated.
			if( _mapChanged ){
				_mapChanged = false;
				updateMappings();
				_connectionsStale = true;
			}
			
			// re-draws the connection arrows
			if( _connectionsStale ){
				_connectionsStale = false;
				drawConnections( unscaledWidth, unscaledHeight );
			}
			
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
		
		/**
		 * @inheritDoc 
		 */		
		override public function stylesInitialized():void {
			if( this.getStyle('backgroundColor') == null ){
				this.setStyle('backgroundColor', 0xFFFFFF);
			}
			super.stylesInitialized();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function createChildren():void {
			if( !_swimLanesSprite ){
				_swimLanesSprite = new UIComponent();
				this.addChild( _swimLanesSprite );
			}
			if( !_connectionSprite ){
				_connectionSprite = new UIComponent();
				this.addChild( _connectionSprite )
			}
			super.createChildren();
		}
		
	}
}
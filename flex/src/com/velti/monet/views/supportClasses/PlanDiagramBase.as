package com.velti.monet.views.supportClasses {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.containers.PannableCanvas;
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.SwimLane;
	import com.velti.monet.utils.DrawingUtil;
	import com.velti.monet.utils.PivotUtils;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.IList;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.osflash.thunderbolt.Logger;
	
	/**
	 * Implements the base functionality of the Plan Diagram view.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanDiagramBase extends PannableCanvas {
		
		// ================= Public Properties ===================

		/**
		 * @private 
		 */		
		private var _plan:Plan;
		
		/**
		 * The plan that we are visually displaying.
		 */
		public function get plan():Plan {
			return _plan;
		}
		
		/**
		 * @private
		 */
		public function set plan(value:Plan):void {
			if( value != _plan ){
				if( _plan ){
					_plan.removeEventListener(CollectionEvent.COLLECTION_CHANGE, plan_collectionChange);
				}
				_plan = value;
				if( _plan ){
					_plan.addEventListener(CollectionEvent.COLLECTION_CHANGE, plan_collectionChange);
				}
				_planChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>plan</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _planChanged:Boolean = false;
		
		/**
		 * @private 
		 */		
		private var _pivotElements:IndexedCollection;;
		
		/**
		 * The set of elements we are currently "pivoting" on,
		 * if any.
		 */
		public function get pivotElements():IndexedCollection {
			return _pivotElements;
		}
		
		/**
		 * @private
		 */
		public function set pivotElements(value:IndexedCollection):void {
			if( value != _pivotElements ){
				if( _pivotElements ){
					_pivotElements.removeEventListener(CollectionEvent.COLLECTION_CHANGE, pivotElements_collectionChange);
				}
				_pivotElements = value;
				if( _pivotElements ){
					_pivotElements.addEventListener(CollectionEvent.COLLECTION_CHANGE, pivotElements_collectionChange);
				}
				_pivotElementsChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>pivotElements</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _pivotElementsChanged:Boolean = false;
		
		/**
		 * The element, if any, that the user currently wants to pivot on. 
		 */		
		public var pivotElement:Element;
		
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
		private var _hasSwimLanes:Boolean = false;
		
		/**
		 * Determines whether or not to draw the "swim-lane"
		 * dividers in the background of this view.
		 */
		public function get hasSwimLanes():Boolean {
			return _hasSwimLanes;
		}
		
		/**
		 * @private
		 */
		public function set hasSwimLanes(value:Boolean):void {
			if( value != _hasSwimLanes ){
				_hasSwimLanes = value;
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
		private var _hasAngledConnections:Boolean;
		
		/**
		 * True if you want to display connections between
		 * nodes as angles, false if you want to draw lines directly.
		 */
		public function get hasAngledConnections():Boolean {
			return _hasAngledConnections;
		}
		
		/**
		 * @private
		 */
		public function set hasAngledConnections(value:Boolean):void {
			if( value != _hasAngledConnections ){
				_hasAngledConnections = value;
				_angledConnectionsChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * True if the value of <code>angledConnections</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _angledConnectionsChanged:Boolean = false;
		
		/**
		 * Event dispatcher set by swiz.
		 */
		public function get dispatcher():IEventDispatcher {
			return _dispatcher;
		}
		/**
		 * @private 
		 */
		[Dispatcher]
		public function set dispatcher(value:IEventDispatcher):void {
			_dispatcher = value;
		}
		
		/**
		 * @private
		 */
		private var _dispatcher:IEventDispatcher;
		
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

		/**
		 * A set of elements, that, if it contains any,
		 * will be on the only set of elements actually displayed on screen.
		 * 
		 * If the set of elements is empty, all elements in the plan
		 * will be displayed on screen. 
		 */		
		protected var _relevantElements:IndexedCollection = new IndexedCollection("elementID");
		
		/**
		 * The point (between 0.0-1.0) at which a right angle connection type breaks
		 * to move vertically. 
		 * 
		 * @default 0.5
		 */		
		protected var connectionBreaksAtPercentage:Number = 0.5;
		
		/**
		 * The amount to add to the horizontal position of each element positioned
		 * in this plan diagram. 
		 */		
		protected var horizontalPadding:Number = 10;
		
		/**
		 * The amount to add to the vertical position of each element positioned
		 * in this plan diagram. 
		 */		
		protected var verticalPadding:Number = 100;
		
		/**
		 * The amount of space to put between renderers in adjacent columns.
		 */		
		protected var columnSpacing:Number = 105;
		
		/**
		 * The amount of space to put between renderers in adjacent rows. 
		 */		
		protected var rowSpacing:Number = 90;
		
		// ================= Constructor ===================
		
		/**
		 * Constructor. 
		 */		
		public function PlanDiagramBase() {
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
			addEventListener(MouseEvent.MOUSE_UP, this_mouseUp);
		}
		
		/**
		 * Cleans up the default event listeners for this component. 
		 */		
		protected function this_removedFromStage( e:Event ):void {
			removeEventListener(DragEvent.DRAG_ENTER, this_dragEnter);
			removeEventListener(DragEvent.DRAG_DROP, this_dragDrop);
			removeEventListener(MouseEvent.MOUSE_UP, this_mouseUp );
		}
		
		/**
		 * Handles the user mousing up on the diagram to check if we
		 * should deselect nodes. 
		 */		
		protected function this_mouseUp( event:MouseEvent ):void {
			if( !(event.target is IElementRenderer) ){
				dispatcher.dispatchEvent( new ElementEvent( ElementEvent.DESELECT ) );
			}
		}
		
		/**
		 * Called when the user moves the drag proxy onto the drop target. 
		 */		
		protected function this_dragEnter(event:DragEvent):void {
			Logger.debug( 'plan diagram base drag enter' );
			
			// Accept the drag only if the user is dragging data 
			// identified by the 'element' format value.
			if( event.dragSource.hasFormat('element') && this.plan && this.plan.length > 0 ){
				// Accept the drop.
				DragManager.acceptDragDrop(this);
			}
		}
		
		/**
		 * Called if the target accepts the dragged object and the user
		 * releases the mouse button while over the PlanDiagramBase container.
		 */		
		protected function this_dragDrop(event:DragEvent):void {
			Logger.debug( 'plan diagram base drag drop' );
			
			// Get the data identified by the color format 
			// from the drag source.
			var droppedElement:Element = event.dragSource.dataForFormat( 'element' ) as Element;
			// TODO: this needs to handle dropping the same element in multiple places?
			if( droppedElement ){
				if( droppedElement.isTemplate ){
					var newElement:Element = new Element( droppedElement.type );
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_ELEMENT, newElement ) );
				}
			}
		}    
		
		/**
		 * Handles the plan collection being modified.
		 */		
		protected function plan_collectionChange( e:CollectionEvent ):void {
			_planChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * Handles the plan collection being modified.
		 */		
		protected function pivotElements_collectionChange( e:CollectionEvent ):void {
			_pivotElementsChanged = true;
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
					_swimLaneLabels.push( new Label() ); // NO PMD
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
		 * diagram is maintaining match.  
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
				if( plan.getItemByIndex( renderer.elementUID ) == null ){
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
			for each( element in plan ){
				if( _renderers.getItemByIndex( element.elementID ) == null ){
					renderer = new elementRenderer() as IElementRenderer; // NO PMD
					renderer.element = element;
					_renderers.addItem( renderer );
					this.addChild( renderer as DisplayObject );
				}
			}
			Logger.debug( "PlanDiagramBase::generateRenderers > Total generated renderers: " + _renderers.length );
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
			Logger.debug( "PlanDiagramBase::clearRenderers > Cleared all renderers." );
		}
		
		/**
	 	 * Updates the positioning of the element renderers on the screen. 
		 */		
		protected function layoutRenderers():void {
			Logger.debug( 'PlanDiagramBase::layoutRenderers > laying out ' + _renderers.length + ' renderers.' );
			
			var rowOffset:int = 0;
			for each( var campaign:Element in plan.campaigns ){
				rowOffset += layoutElementDescendents( campaign, 0, rowOffset );
			}
			// re-position the pivotal elements to match the location of the pivot element
			if( pivotElement ){
				var pivotRenderer:IElementRenderer = getRendererForElement( pivotElement );
				if( pivotRenderer ){
					var renderer:IElementRenderer;
					for each( var element:Element in pivotElements ){
						renderer = getRendererForElement( element );
						renderer.x = pivotRenderer.x;
						renderer.y = pivotRenderer.y;
					}
				}
			}
		}
		
		/**
		 * Positions an element's renderer and the renderers of all its descendent elements on screen.
		 * 
		 * @param element the Element whose branch you want to layout on screen
		 * @param columnOffset the column number that this branch should start being laid out at
		 * @param rowOffset the row number that this branch should start being laid out at
		 * 
		 * @return the max height of this branch 
		 */		
		protected function layoutElementDescendents( element:Element, columnOffset:int, rowOffset:int ):int {
			var descendentElements:Array = element.descendents.toArray();			
			var renderer:IElementRenderer;
			
			var cumulativeSubBranchHeight:int = 0;
			
			if( descendentElements.length > 0 ){
				for( var i:int = 0; i < descendentElements.length; i++ ){
					cumulativeSubBranchHeight += layoutElementDescendents( descendentElements[i] as Element, columnOffset + 1, rowOffset + cumulativeSubBranchHeight );
				}
			}
			
			// if we're not pivoting, or this element is relevant to the pivot, lay out
			// its renderer
			if( !pivotElement || _relevantElements.getItemByIndex( element.elementID ) ){
				renderer 	= getRendererForElement( element );
				renderer.visible = renderer.includeInLayout = true;
				renderer.x 	= ( columnOffset * columnSpacing ) + horizontalPadding;
				renderer.y	= ( rowOffset * rowSpacing ) + verticalPadding;
				
				if( descendentElements.length > cumulativeSubBranchHeight ){
					cumulativeSubBranchHeight = descendentElements.length;
				}else if( cumulativeSubBranchHeight == 0 ){
					cumulativeSubBranchHeight = 1;
				}
			}else{
				renderer 	= getRendererForElement( element );
				renderer.visible = renderer.includeInLayout = false;
			}
			return cumulativeSubBranchHeight;
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
			if( plan && plan.campaigns ){
				for( var i:int = 0; i < plan.campaigns.length; i++ ){
					var planElement:Element = plan.campaigns.getItemAt( i ) as Element;
					_drawConnections( planElement, _connectionSprite.graphics );				
				}
			}

		}
		
		/**
		 * Attempts to draw an arrow between a map and its nodes recursively.
		 * 
		 * @param element the element whose connections you want to draw
		 * @param g the graphics instance you want to draw with
		 */		
		protected function _drawConnections( element:Element, g:Graphics ):void {
			if( element && element.descendents && element.descendents.length > 0 && g ){
				var rootRenderer:IElementRenderer = _renderers.getItemByIndex( element.elementID ) as IElementRenderer;
				
				if( rootRenderer ){
					var elements:Array = element.descendents.toArray();
					var targetRenderer:IElementRenderer;
					var startPoint:Point 	= new Point();
					var endPoint:Point 		= new Point();
					
					for each( var targetElement:Element in elements ){
						// if we're not pivoting, or this element is relevant to the pivot,
						// draw its connections
						if( !pivotElement || _relevantElements.getItemByIndex( targetElement.elementID ) ){
							targetRenderer 	= _renderers.getItemByIndex( targetElement.elementID ) as IElementRenderer;
							startPoint.x 	= rootRenderer.x + ( rootRenderer.width / 2 );
							startPoint.y 	= rootRenderer.y + ( rootRenderer.height / 2 );
							endPoint.x 		= targetRenderer.x + ( targetRenderer.width / 2 );
							endPoint.y 		= targetRenderer.y + ( targetRenderer.height / 2 );
							if( hasAngledConnections ){
								DrawingUtil.drawRightAngleLine( startPoint, endPoint, g, connectionBreaksAtPercentage );
							}else{
								DrawingUtil.drawStraightLine( startPoint, endPoint, g );
							}
							_drawConnections( targetElement, g );
						}
					}
				}
			}
		}
		
		/**
		 * Retrieves the IElementRenderer associated with the given
		 * <code>element</code>, if any.
		 * 
		 * @param element The element whose renderer you want.
		 * @return the associated IElementRenderer, if any exists
		 */		
		protected function getRendererForElement( element:Element ):IElementRenderer {
			return _renderers.getItemByIndex( element.elementID ) as IElementRenderer;
		}
		
		/**
		 * Generates the set of elements that should be rendered
		 * on screen given the current pivot element.
		 */		
		protected function filterRelevantElementsForPivot():void {
			if( pivotElement ){
				_relevantElements = PivotUtils.getRelevantElementsForPivoting( pivotElements.toArray() );
			}else{
				_relevantElements.removeAll();
			}
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
				_planChanged = true;
				_connectionsStale = true;
				this.invalidateDisplayList();
			}
			
			// Handles the plan hash backing this view being updated.
			if( _planChanged ){
				_planChanged = false;
				if( plan ){
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
			
			// handles the set of pivot elements being updated
			if( _pivotElementsChanged ){
				filterRelevantElementsForPivot();
				_renderersStale = true;
				this.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Handles the plan describing the diagram being updated.
			if( _renderersStale ){
				_renderersStale = false;
				layoutRenderers();
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
				if( hasSwimLanes ){
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
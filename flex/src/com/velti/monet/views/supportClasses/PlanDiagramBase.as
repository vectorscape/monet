package com.velti.monet.views.supportClasses {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.containers.PannableCanvas;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.SwimLane;
	import com.velti.monet.utils.DrawingUtil;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.IList;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.swizframework.core.IDispatcherAware;
	
	/**
	 * Implements the base functionality of the Plan Diagram view.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanDiagramBase extends PannableCanvas implements IDispatcherAware {
		
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
		protected var horizontalPadding:Number = 100;
		
		/**
		 * The amount to add to the vertical position of each element positioned
		 * in this plan diagram. 
		 */		
		protected var verticalPadding:Number = 60;
		
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
			trace( 'plan diagram base drag enter' );
			
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
			trace( 'plan diagram base drag drop' );
			
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
					renderer = new elementRenderer() as IElementRenderer;
					renderer.element = element;
					_renderers.addItem( renderer );
					this.addChild( renderer as DisplayObject );
				}
			}
			trace( "PlanDiagramBase::generateRenderers > Total generated renderers: " + _renderers.length );
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
			trace( "PlanDiagramBase::clearRenderers > Cleared all renderers." );
		}
		
		/**
	 	 * Updates the positioning of the element renderers on the screen. 
		 */		
		protected function layoutRenderers():void {
			
			trace( 'PlanDiagramBase::layoutRenderers > laying out ' + _renderers.length + ' renderers.' );
			
			// 1. for each audience branch, determine the max height of that branch
			var maxElementsPerLevelInBranch:int = 1;
			var horizontalOffset:Number = Math.max( 150, this.width / 6 );
			var rowCount:Number = 0;
			var rowOffset:Number = 0;
			var renderer:IElementRenderer;
			for( var i:int = 0; i < plan.campaigns.length; i++ ){
				var planElement:Element = plan.campaigns.getItemAt( i ) as Element;
//				maxElementsPerLevelInBranch = PlanUtils.measureWidthOfBranch( planElement.descendents.toArray(), plan );
//				verticalSpace = maxElementsPerLevelInBranch * 125;
				rowCount = layoutElementDescendents( planElement, 1, horizontalOffset, rowOffset );
				renderer = _renderers.getItemByIndex( planElement.elementID ) as IElementRenderer;
				renderer.x = horizontalPadding;
				renderer.y = /*(rowCount * 125 / 2) + */( ( rowOffset ) * 125) + verticalPadding;
				trace( "\n\nPositioning element("+ planElement.elementID + ") of type " + planElement.type.name + " at " + renderer.x + " x " + renderer.y );
				trace( 'at the plan level rowCount is ' + rowCount + ' and rowOffset is ' + rowOffset );
				rowOffset += rowCount;
			}
		}

		/**
		 * 
		 * @param element
		 * @param level
		 * @param horizontalOffset
		 * @param verticalSpace
		 * @param verticalOffset
		 * 
		 * @return
		 */		
		protected function layoutElementDescendents( element:Element, level:int, horizontalOffset:Number, rowOffset:Number ):Number {
			var descendentElements:Array = plan.getDescendentElementsOfElement( element );
			var renderer:IElementRenderer;
			var descendentElement:Element;
			var descendentRowCount:Number;
			var cumulativeRowCount:Number = 0;
			
			for( var i:int = 0; i < descendentElements.length; i++ ){
				descendentElement 	= descendentElements[ i ] as Element;
				descendentRowCount 	= layoutElementDescendents( descendentElement, level + 1, horizontalOffset, rowOffset + cumulativeRowCount );
				renderer 			= _renderers.getItemByIndex( descendentElement.elementID ) as IElementRenderer;
				renderer.x 			= level * horizontalOffset + horizontalPadding;
				var localOffset:Number = i - 1;
				if( localOffset < 0 ){
					localOffset = 0;
				}
				renderer.y 			= ( ( Math.max( cumulativeRowCount, i ) + rowOffset ) * 125 ) + verticalPadding;
				cumulativeRowCount 	+= descendentRowCount;
				
				trace( "Positioning element("+ descendentElement.elementID + ") of type " + descendentElement.type.name + " at " + renderer.x + " x " + renderer.y );
				trace( 'because rowOffset is: ' + rowOffset + " and cumulative row count is: " + cumulativeRowCount + " and i is: " + i );
			}

			var rowCount:Number = cumulativeRowCount > descendentElements.length ? cumulativeRowCount : descendentElements.length;
			trace( 'at the ' + element.type + ' level rowCount is ' + rowCount + ' and rowOffset is ' + rowOffset );
			return rowCount;
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
					var elements:Array = plan.getDescendentElementsOfElement( element );
					var targetRenderer:IElementRenderer;
					var startPoint:Point 	= new Point();
					var endPoint:Point 		= new Point();
					
					for each( var targetElement:Element in elements ){
						targetRenderer 	= _renderers.getItemByIndex( targetElement.elementID ) as IElementRenderer;
						startPoint.x 	= rootRenderer.x + ( rootRenderer.width / 2 );
						startPoint.y 	= rootRenderer.y + ( rootRenderer.height / 2 );
						endPoint.x 		= targetRenderer.x + ( targetRenderer.width / 2 );
						endPoint.y 		= targetRenderer.y + ( targetRenderer.height / 2 );
						if( angledConnections ){
							DrawingUtil.drawRightAngleLine( startPoint, endPoint, g, connectionBreaksAtPercentage );
						}else{
							DrawingUtil.drawStraightLine( startPoint, endPoint, g );
						}
						_drawConnections( targetElement, g );
					}
				}
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
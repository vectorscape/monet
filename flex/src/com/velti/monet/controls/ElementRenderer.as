package com.velti.monet.controls
{
	import com.velti.monet.events.ElementRendererEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementStatus;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.InteractionType;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.views.supportClasses.IElementRenderer;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.BitmapAsset;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.DragManager;
	
	[Style(name="completeColor", type="uint", inherit="yes")]
	[Style(name="incompleteColor", type="uint", inherit="yes")]
	/**
	 * The UI object that renders a node on the screen. 
	 * @author Clint Modien
	 * 
	 */	
	public class ElementRenderer extends Canvas implements IElementRenderer
	{	
		/**
		 * Default sizing characteristic. 
		 */		
		public static const DEFAULT_WIDTH:Number = 110;
		
		/**
		 * Default sizing characteristic. 
		 */		
		public static const DEFAULT_HEIGHT:Number = 75;
		
		/**
		 * Default number of pixels the user must move an element
		 * before it begins dragging.
		 */		
		public static const MIN_DRAG_THRESHOLD:Number = 5;
		
		/**
		 * Event dispatcher set by swiz. 
		 */		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		/**
		 * Handle to the global presentation model. 
		 */		
		[Inject]
		public var presentationModel:PresentationModel;
		
		/**
		 * Handle to the globally selected element. 
		 */
		[Inject(source="presentationModel.selectedElement", bind="true")]
		public function set selectedElement( value:Element ):void { // NO PMD
			// TODO: this can be more efficient than invalidating all renderers
			this.invalidateDisplayList();
		}
		
		/**
		 * The object used to draw the ellipse onto
		 */		
		protected var skin:UIComponent;
		/**
		 * Whether or not the alpha property has changed 
		 */		
		private var alphaChanged:Boolean;
		/**
		 * The mx label used to render text over the ellipse
		 */		
		protected var labelText:Text;
		
		/**
		 * The type of node (e.g. ElementType.PLAN)
		 * @see com.velti.monet.models.ElementType.PLAN
		 * 
		 */		
		public function get type():ElementType {
			return element ? element.type : null;
		}
		
		/**
		 * @private 
		 */		
		private var _element:Element;
		
		/**
		 * @copyDoc com.velti.monet.views.supportClasses.IElementRenderer#element
		 */
		public function get element():Element {
			return _element;
		}
		
		/**
		 * @private
		 */
		public function set element(value:Element):void {
			if( value != _element ){
				if(_element) _element.removeEventListener(Element.PROPERTY_CHANGED, element_dataChanged);
				_element = value;
				if(_element) _element.addEventListener(Element.PROPERTY_CHANGED, element_dataChanged, false,0,true);
				_elementChanged = true;
				this.invalidateProperties();
			}
		}
		
		private function element_dataChanged(event:Event):void {
			_elementChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * True if the value of <code>element</code> has changed
		 * since the last call to <code>commitProperties</code>. 
		 */
		protected var _elementChanged:Boolean = false;
		
		/**
		 * @copyDoc com.velti.monet.views.supportClasses.IElementRenderer#elementUID 
		 */		
		public function get elementUID():String {
			return element ? element.elementID : null;
		}
		
		/**
		 * The position where the user moused down. 
		 */		
		protected var _mouseDownPosition:Point;
		
		
		/**
		 * True if the user is currently hovering their mouse
		 * over this renderer. 
		 */		
		protected var _hovered:Boolean = false;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ElementRenderer() {
			super();
			this.doubleClickEnabled = true;
			this.mouseChildren = false;
			addEventListener(Event.ADDED_TO_STAGE,this_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this_removedFromStage);
		}
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			ElementStatus.COMPLETE.color = getStyle("completeColor");
			ElementStatus.INCOMPLETE.color = getStyle("incompleteColor");
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override public function styleChanged(styleProp:String):void {
			//use this for runtime css support
			super.styleChanged(styleProp);
			/*switch(styleProp) {
			case "someStyle" : 
			someStyleChanged = true;
			invalidateProperties();
			break;
			}*/
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function createChildren():void {
			super.createChildren();
			
			skin = new UIComponent();
			this.addChild(skin);
			
			labelText = new Text();
			labelText.truncateToFit = true;
			labelText.setStyle("textAlign","center");
			labelText.setStyle("verticalCenter", 0);
			addChild(labelText);
		}
		
		/**
		 * @inheritDoc 
		 */		
		override protected function measure():void {
			super.measure();
			if( isNaN( width ) || width == 0 ){
				width = DEFAULT_WIDTH;
				this.invalidateDisplayList();
			}
			if( isNaN( height ) || height == 0 ){
				height = DEFAULT_HEIGHT;
				this.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			drawSkin();
			
			labelText.width = unscaledWidth - 5;
			labelText.maxHeight = unscaledHeight;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function commitProperties():void {
			super.commitProperties();
			if(alphaChanged) {
				alphaChanged = false;
				drawSkin();
			}
			
			if( _elementChanged ){
				_elementChanged = false;
				if( element ){
					labelText.text = element.label ? element.label : resourceManager.getString('UI', element.type.name);
					labelText.toolTip = labelText.text;
					drawSkin();
				}else{
					labelText.text = null;
					labelText.toolTip = null;
					skin.visible = false;
				}
			}
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override public function set alpha(value:Number):void {
			super.alpha = value;
			alphaChanged = true;
			invalidateProperties();
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		protected function drawSkin():void {
			if( element ){
				skin.visible = true;
				skin.graphics.clear();
				if( presentationModel && presentationModel.selectedElement == this.element ){
					skin.graphics.lineStyle(3);
				}else{
					skin.graphics.lineStyle(1);
				}
				skin.graphics.beginFill(element.status.color, this.alpha);
				if( _hovered ){
					skin.graphics.drawEllipse(-1,-1,unscaledWidth + 1, unscaledHeight + 1);
				}else{
					skin.graphics.drawEllipse(1,1,unscaledWidth-2, unscaledHeight-2);
				}
				skin.graphics.endFill();
			}
		}
		
		
		// ==================== Event Listeners ========================
		
		/**
		 * Sets up the rest of the default event listeners for this component. 
		 */		
		protected function this_addedToStage( e:Event ):void {
			addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDown);
			if(this.element && !this.element.isTemplate ){
				addEventListener(MouseEvent.DOUBLE_CLICK, this_doubleClick);
				addEventListener(DragEvent.DRAG_ENTER, this_dragEnter);
				addEventListener(DragEvent.DRAG_DROP, this_dragDrop);
				addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
				addEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
			}
		}
		
		/**
		 * Cleans up the default event listeners for this component. 
		 */		
		protected function this_removedFromStage( e:Event ):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, this_mouseDown);
			if(this.element && !this.element.isTemplate ){
				removeEventListener(MouseEvent.DOUBLE_CLICK, this_doubleClick);
				removeEventListener(DragEvent.DRAG_ENTER, this_dragEnter);
				removeEventListener(DragEvent.DRAG_DROP, this_dragDrop);
				removeEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
				removeEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
			}
		}
		
		/**
		 * Adds extra mouse listeners needed after mouseDown. 
		 */
		protected function addExtraMouseListeners():void {
			addEventListener(MouseEvent.MOUSE_UP, this_mouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMove);
		}
		
		/**
		 * Removes extra mouse listeners needed after mouseDown. 
		 */
		protected function removeExtraMouseListeners():void {
			removeEventListener(MouseEvent.MOUSE_UP, this_mouseUp);
			removeEventListener(MouseEvent.MOUSE_MOVE, this_mouseMove);
			_mouseDownPosition = null;
		}
		
		/**
		 * Sets up the renderer for a drag and drop operation.
		 */		
		protected function this_mouseDown(event:MouseEvent):void {
			event.stopImmediatePropagation();
			_mouseDownPosition = new Point( event.stageX, event.stageY );
			addExtraMouseListeners();
			
			// select this element
			if( !this.element.isTemplate ){
				dispatcher.dispatchEvent( new ElementRendererEvent( ElementRendererEvent.SELECT, this.element ) );
			}
		}
		
		/**
		 * Handles the user moving the mouse over this renderer.
		 */		
		protected function this_mouseOver(event:MouseEvent):void {
			_hovered = true;
			this.invalidateDisplayList();
		}
		
		/**
		 * Handles the user moving the mouse off of this renderer.
		 */		
		protected function this_mouseOut(event:MouseEvent):void {
			_hovered = false;
			this.invalidateDisplayList();
			removeExtraMouseListeners();
		}
		
		/**
		 * Initializes the drag and drop operation.
		 */		
		protected function this_mouseUp(event:MouseEvent):void {
			removeExtraMouseListeners();
		}
		
		/**
		 * Initializes the drag and drop operation.
		 */		
		protected function this_mouseMove( event:MouseEvent ):void {
			// only start drag if the user has been holding the mouse down and actually dragging the renderer
			if( _mouseDownPosition && Math.abs(event.stageX - _mouseDownPosition.x ) > MIN_DRAG_THRESHOLD || Math.abs(event.stageY - _mouseDownPosition.y ) > MIN_DRAG_THRESHOLD ){
				// Create a DragSource object.
				var dragSource:DragSource = new DragSource();
				
				// Add the data to the object.
				dragSource.addData(element, 'element');
				
				// Create the drag proxy
				var dragProxy:BitmapAsset 	= new BitmapAsset(ImageSnapshot.captureBitmapData( this ));
				dragProxy.width 			= this.width;
				dragProxy.height 			= this.height;
				
				// Call the DragManager doDrag() method to start the drag. 
				DragManager.doDrag( this, dragSource, event, dragProxy );
				removeEventListener(MouseEvent.MOUSE_MOVE, this_mouseMove);	
			}
		}
		
		/**
		 * Called when the user moves the drag proxy onto the drop target. 
		 */		
		protected function this_dragEnter(event:DragEvent):void {
			trace( 'element renderer drag enter' );
			// Accept the drag only if the user is dragging data 
			// identified by the 'element' format value.
			var draggedElement:Element = event.dragSource.hasFormat('element') ? event.dragSource.dataForFormat( 'element' ) as Element : null;
			if( draggedElement && draggedElement != this.element ){
				// Accept the drop.
				DragManager.acceptDragDrop(this);
			}
			
			// allows dropping of interactions onto interactions or advertisements
			if( this.element.type == ElementType.INTERACTION || this.element.type == ElementType.ADVERTISEMENT ){
				var interactionType:InteractionType = event.dragSource.hasFormat('items') ? (event.dragSource.dataForFormat( 'items' ) as Array)[0]: null;
				if( interactionType ){
					// Accept the drop.
					DragManager.acceptDragDrop(this);
				}
			}
		}
		
		/**
		 * Called if the target accepts the dragged object and the user
		 * releases the mouse button while over the ElementRenderer instance.
		 */		
		protected function this_dragDrop(event:DragEvent):void {
			trace( 'element renderer drag drop' );
			
			// Get the data identified by the color format 
			// from the drag source.
			var droppedElement:Element = event.dragSource.dataForFormat( 'element' ) as Element;
			// TODO: this needs to handle dropping the same element in multiple places?
			if( droppedElement ){
				if( droppedElement.isTemplate ){
					var newElement:Element = new Element( droppedElement.type );
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_ELEMENT, newElement, this.element ) );
				}else{
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.MOVE_ELEMENT, droppedElement, this.element ) );
				}
			}
			
			// allows dropping of interactions onto interactions or advertisements
			if( this.element.type == ElementType.INTERACTION || this.element.type == ElementType.ADVERTISEMENT ){
				var interactionType:InteractionType = event.dragSource.hasFormat('items') ? (event.dragSource.dataForFormat( 'items' ) as Array)[0]: null;
				if( interactionType ){				
					if( element.type == ElementType.INTERACTION ){
						this.element.label = interactionType.label;
					}else{
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_INTERACTION, this.element, null, interactionType ) );
					}
				}
			}
		}
		
		/**
		 * Handles the user clicking on this renderer.
		 */		
		protected function this_doubleClick(event:MouseEvent):void {
			trace( 'double click' );
			dispatcher.dispatchEvent( new ElementRendererEvent( ElementRendererEvent.SHOW_DETAILS, this.element ) );
		}
	}
}
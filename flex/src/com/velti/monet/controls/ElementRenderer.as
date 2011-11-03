package com.velti.monet.controls
{
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.events.ElementEvent;
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.AdvertisementType;
	import com.velti.monet.models.CreativeLibraryItem;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementStatus;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.InteractionType;
	import com.velti.monet.models.PresentationModel;
	import com.velti.monet.models.SubType;
	import com.velti.monet.utils.ElementUtils;
	import com.velti.monet.views.Cursors;
	import com.velti.monet.views.supportClasses.IElementRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.BitmapAsset;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.DragManager;
	
	import org.osflash.thunderbolt.Logger;
	
	[Style(name="completeFillColor", type="uint", inherit="yes")]
	[Style(name="completeStrokeColor", type="uint", inherit="yes")]
	[Style(name="incompleteFillColor", type="uint", inherit="yes")]
	[Style(name="incompleteStrokeColor", type="uint", inherit="yes")]
	
	[Style(name="selectedBorderWidth", type="uint", inherit="yes")]
	[Style(name="deSelectedBorderWidth", type="uint", inherit="yes")]
	
	/**
	 * The UI object that renders a node on the screen. 
	 * @author Clint Modien
	 * 
	 */	
	public class ElementRenderer extends Canvas implements IElementRenderer
	{	
		private var completeFillColor:uint;
		private var completeStrokeColor:uint;
		private var incompleteStrokeColor:uint;
		private var incompleteFillColor:uint;
		private var selectedBorderWidth:uint;
		private var deSelectedBorderWidth:uint;
		
		protected var modeImage:Image;
		
		/**
		 * Default sizing characteristic. 
		 */		
		public static const DEFAULT_WIDTH:Number = 80;
		
		/**
		 * Default sizing characteristic. 
		 */		
		public static const DEFAULT_HEIGHT:Number = 60;
		
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
		[Inject(source="presentationModel.selectedElements", bind="true")]
		public function set selectedElements( value:IndexedCollection ):void { // NO PMD
			// TODO: this can be more efficient than invalidating all renderers
			if( value ){
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, selectedElements_changed, false, 0, true );
			}
			this.invalidateDisplayList();
		}
		
		/**
		 * Whether or not this renderer should draw itself highlighted 
		 */
		public function set highlighted( value:Boolean ):void { // NO PMD
			// TODO: this can be more efficient than invalidating all renderers
			if( _highlighted != value ){
				_highlighted = value;
				this.invalidateDisplayList();
			}
		}
		/**
		 * @private 
		 */		
		public function get highlighted():Boolean {
			return _highlighted;
		}
		/**
		 * @private 
		 */
		protected var _highlighted:Boolean = false;
		
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
				if(_element) _element.removeEventListener(ElementEvent.DATA_CHANGE, element_dataChanged);
				if(_element) _element.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, element_propChanged);
				_element = value;
				if(_element) _element.addEventListener(ElementEvent.DATA_CHANGE, element_dataChanged, false,0,true);
				if(_element) _element.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, element_propChanged, false,0,true);
				_elementChanged = true;
				this.invalidateProperties();
			}
		}
		
		private function element_dataChanged(event:Event):void {
			_elementChanged = true;
			this.invalidateProperties();
		}
		
		private function element_propChanged(event:Event):void {
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
		
		[PostConstruct]
		public function postConstruct():void {
			BindingUtils.bindSetter(wandedElement_change,presentationModel,"wandedElement");
		}
		private function wandedElement_change(e:Element):void {
			updateWandElement();
		}
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			completeFillColor = getStyle("completeFillColor");
			completeStrokeColor = getStyle("completeStrokeColor");
			incompleteStrokeColor = getStyle("incompleteStrokeColor");
			incompleteFillColor = getStyle("incompleteFillColor");
			selectedBorderWidth = getStyle("selectedBorderWidth");
			deSelectedBorderWidth = getStyle("deSelectedBorderWidth");
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
			labelText.setStyle("paddingLeft",8);
			labelText.setStyle("paddingRight",8);
			labelText.setStyle("textAlign","center");
			labelText.setStyle("verticalCenter", 0);
			addChild(labelText);
			
			modeImage = new Image();
			addChild(modeImage);
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
			
			labelText.width = unscaledWidth;
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
				var strokeColor:uint = 
					element.status == ElementStatus.COMPLETE ? completeStrokeColor : incompleteStrokeColor ;
				if( highlighted ){
					skin.graphics.lineStyle(5,0x53FE7D);
				}else if( presentationModel && presentationModel.selectedElements.contains( this.element ) ){
					skin.graphics.lineStyle(selectedBorderWidth,strokeColor);
				}else{
					skin.graphics.lineStyle(deSelectedBorderWidth,strokeColor);
				}
				var fillColor:uint = 
					element.status == ElementStatus.COMPLETE ? completeFillColor : incompleteFillColor ;
				skin.graphics.beginFill(fillColor, this.alpha);
				if( _hovered ){
					skin.graphics.drawRect(-1,-1,unscaledWidth + 1, unscaledHeight + 1);
				}else{
					skin.graphics.drawRect(1,1,unscaledWidth-2, unscaledHeight-2);
				}
				skin.graphics.endFill();
				
				updateWandElement();
			}
		}
		
		private function updateWandElement():void
		{
			if(!modeImage) return;
			//magic wand
			if(presentationModel && presentationModel.wandedElement == element) {
				modeImage.source = Cursors.MAGIC_WAND;
				modeImage.x = 5;
				modeImage.y = 5;
			} else {
				modeImage.source = null;
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
				addEventListener(DragEvent.DRAG_OVER, this_dragOver);
				addEventListener(DragEvent.DRAG_EXIT, this_dragExit);
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
				removeEventListener(DragEvent.DRAG_OVER, this_dragOver);
				removeEventListener(DragEvent.DRAG_EXIT, this_dragExit);
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
			
			var selected:Boolean = presentationModel.selectedElements.contains( this.element );
			
			// select this element
			if( !this.element.isTemplate ){
				if( event.ctrlKey ){
					dispatcher.dispatchEvent( new ElementEvent( selected ? ElementEvent.REMOVE_FROM_SELECTION : ElementEvent.ADD_TO_SELECTION, this.element ) );
				}else{
					dispatcher.dispatchEvent( new ElementEvent( ElementEvent.SELECT, null, [this.element] ) );
				}
			}
		}
		
		/**
		 * Handles the user moving the mouse over this renderer.
		 */		
		protected function this_mouseOver(event:MouseEvent):void {
			_hovered = true;
			dispatcher.dispatchEvent(new ElementEvent(ElementEvent.HOVERED,this.element));
			this.invalidateDisplayList();
		}
		
		/**
		 * Handles the user moving the mouse off of this renderer.
		 */		
		protected function this_mouseOut(event:MouseEvent):void {
			dispatcher.dispatchEvent(new ElementEvent(ElementEvent.UNHOVERED,this.element));
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
		 * Element handle to support live preview demo functionality. 
		 */		
		protected var _livePreviewElement:Element;
		
		// =================================
		// =================================
		// =================================
		// =================================
		// TODO: [ian] Drag and Drop needs to be refactored into a controller,
		// this code has outgrown its welcome here
		// =================================
		// =================================
		// =================================
		// =================================
		
		/**
		 * Called when the user moves the drag proxy onto the drop target. 
		 */		
		protected function this_dragEnter(event:DragEvent):void {
			Logger.debug( 'element renderer drag enter' );
			// Accept the drag only if the user is dragging data 
			// identified by the 'element' format value.
			var draggedElement:Element = event.dragSource.hasFormat('element') ? event.dragSource.dataForFormat( 'element' ) as Element : null;
			if( draggedElement && draggedElement != this.element ){
				// Accept the drop.
				DragManager.acceptDragDrop(this);
			}
			
			// allows for dropping of ads and interactions
			if( event.dragSource.hasFormat('items') ){
				var items:Array = event.dragSource.dataForFormat( 'items' ) as Array;
				if(items && items.length > 0 && ( items[0] is AdvertisementType || items[0] is InteractionType ) ){ 
					DragManager.acceptDragDrop(this);
				}
				// support dragging creative library items
				if( items && items.length > 0 && items[0] is CreativeLibraryItem && this.element.type == ElementType.ADVERTISEMENT ){
					trace( "accepted creative library item for dropping on ad" );
					DragManager.acceptDragDrop( this );
				}
				// hack to support https://www.pivotaltracker.com/story/show/19974975 for demo purposes
				if( this.element.type == ElementType.INTERACTION && items[0] == InteractionType.VOTE_AND_POLL ){
					var newElement:Element = new Element( ElementType.INTERACTION );
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ASSIGN_INTERACTION, newElement, null, items[0] as InteractionType, false ) );
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_ELEMENT, newElement, this.element, null, false ) );
					_livePreviewElement = newElement;
				}
			}

		}
		
		/**
		 * Called when the user moves the drag proxy away from the drop target. 
		 * 
		 * Hack to support https://www.pivotaltracker.com/story/show/19974975 for demo purposes
		 */		
		protected function this_dragExit(event:DragEvent):void {
			if( _livePreviewElement ){
				dispatcher.dispatchEvent( new PlanEvent( PlanEvent.REMOVE_ELEMENT, _livePreviewElement ) );
				_livePreviewElement = null;
			}
		}
		
		/**
		 * Called if the target accepts the dragged object and the user
		 * is moving the mous over this ElementRenderer instance.
		 */		
		protected function this_dragOver(event:DragEvent):void {
			Logger.debug( 'element renderer drag over' );
			var operation:String = DragManager.NONE;
			var droppedElement:Element = event.dragSource.dataForFormat( 'element' ) as Element;
			var items:Array = event.dragSource.dataForFormat( 'items' ) as Array;
			
			if( droppedElement && droppedElement.isTemplate ){
				operation = DragManager.COPY;
			}else if( droppedElement ){
				operation = DragManager.MOVE;
			}else if( items && items.length > 0 && items[0] is AdvertisementType ){
				operation = this.element.type == ElementType.ADVERTISEMENT ? DragManager.LINK : DragManager.COPY;
			}else if( items && items.length > 0 && items[0] is InteractionType ){
				if( this.element.type == ElementType.INTERACTION && !event.ctrlKey ){
					operation = DragManager.LINK;
				}else{
					operation = DragManager.COPY;
				}
			}else if( items && items.length > 0 && items[0] is CreativeLibraryItem ){
				operation = DragManager.COPY;
			}
			trace( 'operation is: ' + operation );
			DragManager.showFeedback( operation );
		}
		
		/**
		 * Called if the target accepts the dragged object and the user
		 * releases the mouse button while over the ElementRenderer instance.
		 */		
		protected function this_dragDrop(event:DragEvent):void {
			Logger.debug( 'element renderer drag drop' );
			
			// hack to support https://www.pivotaltracker.com/story/show/19974975 for demo purposes
			// at this point the element has already been added via live preview
			if( _livePreviewElement ){
				_livePreviewElement = null;
				return;
			}
			
			// Get the data identified by the element format 
			// from the drag source.
			var droppedElement:Element = event.dragSource.dataForFormat( 'element' ) as Element;
			var newElement:Element;
			
			// TODO: this needs to handle dropping the same element in multiple places
			// and should definitely be moved into a drag and drop controller
			
			// 1. if the dropped item was an element
			if( droppedElement ){
				// 1a. create a new element from a template
				if( droppedElement.isTemplate ){
					newElement = new Element( droppedElement.type );
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_ELEMENT, newElement, this.element ) );
				}
				// 1b. move an existing element to a new location
				else{
					if( ElementUtils.isBlank( this.element ) && droppedElement.type == ElementType.INTERACTION ){
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.REPLACE_ELEMENT, droppedElement, this.element ) );
					}else{
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.MOVE_ELEMENT, droppedElement, this.element ) );
					}
				}
			}
			// 2. if the dropped item was a SubType, this 
			//    allows dropping of advertisement types and interaction types
			else if( event.dragSource.hasFormat('items') ){
				var items:Array = event.dragSource.dataForFormat( 'items' ) as Array;
				
				// user dropped an advertisement type
				if( items[0] is AdvertisementType ){
					// 2a. if they dropped it on an advertisement
					if( this.element.type == ElementType.ADVERTISEMENT ){
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ASSIGN_ADVERTISEMENT, this.element, null, items[0] as AdvertisementType ) );
					}
					// 2b. if they dropped into some other element type
					else{
						newElement = new Element( ElementType.ADVERTISEMENT, (items[0] as AdvertisementType).label );
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ASSIGN_ADVERTISEMENT, newElement, null, items[0] as AdvertisementType ) );
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_ELEMENT, newElement, this.element ) );						
					}
				}
				// user dropped an interaction type
				else if( items[0] is InteractionType ){
					// 2c. if they dropped it onto an interaction and weren't holding the ctrl-key
					if( this.element.type == ElementType.INTERACTION && !event.ctrlKey ){
						// assign it to the current interaction
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ASSIGN_INTERACTION, this.element, null, items[0] as InteractionType ) );
					}
					// 2d. or string it onto the existing interaction or branch, add a new interaction is the default
					else{
						newElement = new Element( ElementType.INTERACTION, (items[0] as InteractionType).label );
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ASSIGN_INTERACTION, newElement, null, items[0] as InteractionType ) );
						dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ADD_ELEMENT, newElement, this.element,null,false ) );
					}
				}
				// user dropped a create library item
				else if( items[0] is CreativeLibraryItem && this.element.type == ElementType.ADVERTISEMENT ){
					dispatcher.dispatchEvent( new PlanEvent( PlanEvent.ASSIGN_CREATIVE_LIBRARY_ITEM, this.element, null, items[0] as CreativeLibraryItem ) );
				}
			}
			
		}
		
		/**
		 * Handles the user clicking on this renderer.
		 */		
		protected function this_doubleClick(event:MouseEvent):void {
			Logger.debug( 'double click' );
			if(element.isTemplate) return;
			dispatcher.dispatchEvent( new ElementEvent( ElementEvent.SHOW_DETAILS, this.element ) );
		}
		
		/**
		 * Called when the collection of selected elements changes. 
		 */		
		protected function selectedElements_changed( e:CollectionEvent ):void {
			this.invalidateDisplayList();
		}
	}
}
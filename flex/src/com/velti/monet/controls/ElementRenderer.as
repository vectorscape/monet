package com.velti.monet.controls
{
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementStatus;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.views.supportClasses.IElementRenderer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.managers.DragManager;
	
	import org.osflash.thunderbolt.Logger;
	
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
		 * The object used to draw the ellipse onto
		 */		
		protected var ellipse:UIComponent;
		/**
		 * Whether or not the alpha property has changed 
		 */		
		private var alphaChanged:Boolean;
		/**
		 * The mx label used to render text over the ellipse
		 */		
		protected var textLabel:Label;

		/**
		 * The type of node (e.g. ElementType.CAMPAIGN)
		 * @see com.velti.monet.models.ElementType.CAMPAIGN
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
				_element = value;
				_elementChanged = true;
				this.invalidateProperties();
			}
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
			return element ? element.uid : null;
		}
		
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
			
			ellipse = new UIComponent();
			this.addChild(ellipse);
			
			textLabel = new Label();
			textLabel.truncateToFit = true;
			textLabel.setStyle("textAlign","center");
			textLabel.setStyle("verticalCenter", 0);
			addChild(textLabel);
			
			this.addEventListener(MouseEvent.CLICK, this_click, false, 0, true);
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
		 * Handles the click event 
		 * @param event
		 * 
		 */		
		protected function this_click(event:MouseEvent):void {
			/*switch(this.status) {
				case NodeStatus.COMPLETE : 
					this.status = NodeStatus.INCOMPLETE;
					break;
				case NodeStatus.INCOMPLETE :
					this.status = NodeStatus.COMPLETE;
					break;
				default :
					Logger.warn("node status: " + status + " not handled");
			}*/
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			drawEllipse();
			
			textLabel.width = unscaledWidth - 2;
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
				drawEllipse();
			}
			
			if( _elementChanged ){
				_elementChanged = false;
				if( element ){
					textLabel.text = element.label ? element.label : resourceManager.getString('UI', element.type.name);
					textLabel.toolTip = textLabel.text;
					drawEllipse();
				}else{
					textLabel.text = null;
					ellipse.visible = false;
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
		protected function drawEllipse():void {
			if( element ){
				ellipse.visible = true;
				ellipse.graphics.clear();
				ellipse.graphics.lineStyle(1);
				ellipse.graphics.beginFill(element.status.color, this.alpha);
				ellipse.graphics.drawEllipse(1,1,unscaledWidth-2, unscaledHeight-2);
				ellipse.graphics.endFill();
			}
		}
		
		// ==================== Event Listeners ========================
		
		/**
		 * Sets up the rest of the default event listeners for this component. 
		 */		
		protected function this_addedToStage( e:Event ):void {
			addEventListener(MouseEvent.MOUSE_MOVE,this_mouseMove);
		}
		
		/**
		 * Cleans up the default event listeners for this component. 
		 */		
		protected function this_removedFromStage( e:Event ):void {
			removeEventListener(MouseEvent.MOUSE_MOVE,this_mouseMove);
		}
		
		/**
		 * Initializes the drag and drop operation.
		 */		
		protected function this_mouseMove(event:MouseEvent):void {
			// Create a DragSource object.
			var dragSource:DragSource = new DragSource();
			
			// Add the data to the object.
			dragSource.addData(element, 'element');
			
			// Call the DragManager doDrag() method to start the drag. 
			DragManager.doDrag( this, dragSource, event );
		}
	}
}
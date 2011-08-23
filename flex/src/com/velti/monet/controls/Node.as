package com.velti.monet.controls
{
	import com.velti.monet.controls.nodeClasses.NodeStatus;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import org.osflash.thunderbolt.Logger;
	
	[Style(name="completeColor", type="uint", inherit="yes")]
	[Style(name="incompleteColor", type="uint", inherit="yes")]
	/**
	 * The UI object that renders a node on the screen. 
	 * @author Clint Modien
	 * 
	 */	
	public class Node extends Canvas
	{	
		/**
		 * The object used to draw the ellipse onto
		 */		
		protected var ellipse:UIComponent;
		/**
		 * Whether or not the alpha property has changed 
		 */		
		private var alphaChanged:Boolean;
		/**
		 * Stores the status for the public getter setter 
		 */		
		private var _status:NodeStatus = NodeStatus.INCOMPLETE;
		/**
		 * Whether or not the status has changed 
		 */		
		private var statusChanged:Boolean;
		/**
		 * The mx label used to render text over the ellipse
		 */		
		protected var textLabel:Label;
		/**
		 * Stores the string used to populate the <code>label</code> 
		 */		
		private var _label:String = "";
		/**
		 * Whether or not the label has changed 
		 */		
		private var labelChanged:Boolean;
		
		/**
		 * The current status of the node.
		 * @see com.velti.monet.controls.nodeClasses.NodeStatus
		 */		
		[Bindable]
		public function get status():NodeStatus {
			return _status;
		}
		/**
		 * @private
		 * 
		 */		
		public function set status(v:NodeStatus):void { 
			this._status = v;
			statusChanged = true;
			invalidateProperties();
		}
		/**
		 * @inheritDoc 
		 */		
		[Bindable]
		override public function get label():String {
			return _label;
		}
		/**
		 * @private
		 * 
		 */				
		override public function set label(v:String):void {
			_label = v;
			labelChanged = true;
			invalidateProperties();
		}
		/**
		 * Constructor 
		 * 
		 */		
		public function Node() {
			super();
		}
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			NodeStatus.COMPLETE.color = getStyle("completeColor");
			NodeStatus.INCOMPLETE.color = getStyle("incompleteColor");
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
			drawEllipse();
			this.addChild(ellipse);
			
			textLabel = new Label();
			textLabel.truncateToFit = true;
			textLabel.setStyle("textAlign","center");
			textLabel.setStyle("verticalCenter", 0);
			addChild(textLabel);
			
			this.addEventListener(MouseEvent.CLICK, this_click, false, 0, true);
		}
		
		/**
		 * Handles the click event 
		 * @param event
		 * 
		 */		
		protected function this_click(event:MouseEvent):void {
			switch(this.status) {
				case NodeStatus.COMPLETE : 
					this.status = NodeStatus.INCOMPLETE;
					break;
				case NodeStatus.INCOMPLETE :
					this.status = NodeStatus.COMPLETE;
					break;
				default :
					Logger.warn("node status: " + status + " not handled");
			}
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			ellipse.height = unscaledHeight;
			ellipse.width = unscaledWidth;
			
			textLabel.width = unscaledWidth - 2;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function commitProperties():void {
			super.commitProperties();
			if(statusChanged || alphaChanged) {
				alphaChanged = statusChanged = false;
				drawEllipse();
			}
			
			if(labelChanged) {
				labelChanged = false;
				textLabel.text = label;
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
			ellipse.graphics.clear();
			ellipse.graphics.lineStyle(1);
			ellipse.graphics.beginFill(status.color, this.alpha);
			ellipse.graphics.drawEllipse(1,1,unscaledWidth-2, unscaledHeight-2);
			ellipse.graphics.endFill();
		}
	}
}
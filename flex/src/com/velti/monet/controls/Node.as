package com.velti.monet.controls
{
	import com.velti.monet.controls.nodeClasses.NodeStatus;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	[Style(name="completeColor", type="uint", inherit="yes")]
	[Style(name="incompleteColor", type="uint", inherit="yes")]
	
	public class Node extends Canvas
	{	
		protected var ellipse:UIComponent;
		protected var alphaChanged:Boolean;
		protected var _status:NodeStatus = NodeStatus.INCOMPLETE;
		protected var statusChanged:Boolean;
		
		protected var textLabel:Label;
		protected var _label:String = "";
		protected var labelChanged:Boolean;
		
		[Bindable]
		public function get status():NodeStatus {
			return _status;
		}
		
		public function set status(v:NodeStatus):void { 
			this._status = v;
			statusChanged = true;
			invalidateProperties();
		}
		
		[Bindable]
		override public function get label():String {
			return _label;
		}
		
		override public function set label(v:String):void {
			_label = v;
			labelChanged = true;
			invalidateProperties();
		}
		
		public function Node() {
			super();
		}
		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			NodeStatus.COMPLETE.color = getStyle("completeColor");
			NodeStatus.INCOMPLETE.color = getStyle("incompleteColor");
		}
		
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

		protected function this_click(event:MouseEvent):void {
			switch(this.status) {
				case NodeStatus.COMPLETE : 
					this.status = NodeStatus.INCOMPLETE;
					break;
				case NodeStatus.INCOMPLETE :
					this.status = NodeStatus.COMPLETE;
					break;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			ellipse.height = unscaledHeight;
			ellipse.width = unscaledWidth;
			
			textLabel.width = unscaledWidth - 2;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
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
		
		override public function set alpha(value:Number):void {
			super.alpha = value;
			alphaChanged = true;
			invalidateProperties();
		}
		
		protected function drawEllipse():void {
			ellipse.graphics.clear();
			ellipse.graphics.lineStyle(1);
			ellipse.graphics.beginFill(status.color, this.alpha);
			ellipse.graphics.drawEllipse(1,1,unscaledWidth-2, unscaledHeight-2);
			ellipse.graphics.endFill();
		}
	}
}
/*
The MIT License
Copyright (c) 2007-2008 Ali Rantakari of hasseg.org
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
// grabed from http://hasseg.org/blog/post/113/collapsible-panel-component-for-flex/
package com.velti.monet.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.core.ScrollPolicy;
	import mx.effects.AnimateProperty;
	import mx.events.FlexEvent;
	/**
	* The icon designating a "closed" state
	*/
	[Style(name="closedIcon", type="Object", inherit="yes")]
	/**
	* The icon designating an "open" state
	*/
	[Style(name="openIcon", type="Object", inherit="yes")]
	/**
	* This is a Panel that can be collapsed and expanded by clicking on the header.
	*
	* @author Ali Rantakari
	*/
	public class CollapsiblePanel extends Panel
	{
		/**
		 * Indicates the control is in the open state 
		 */		
		private var _open:Boolean = true;
		/**
		 * The open/close animation (tween). 
		 */		
		private var _openAnim:AnimateProperty;
		/**
		* Constructor
		*
		*/
		public function CollapsiblePanel() {
			super();
			this.percentWidth = 100;
			_openAnim = new AnimateProperty(this);
			_openAnim.duration = 300;
			_openAnim.property = "height";
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
// BEGIN: event handlers				------------------------------------------------------------
		private function creationCompleteHandler(event:FlexEvent):void
		{
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			titleBar.addEventListener(MouseEvent.CLICK, headerClickHandler);
			updateOpen();
		}
		private function headerClickHandler(event:MouseEvent):void { toggleOpen(); }
// BEGIN: private methods				------------------------------------------------------------
		// sets the height of the component without animation, based
		// on the _open variable
		private function updateOpen():void
		{
			if (!_open) height = closedHeight;
			else height = openHeight;
			setTitleIcon();
		}
		// the height that the component should be when open
		private function get openHeight():Number {
			return measuredHeight;
		}
		// the height that the component should be when closed
		private function get closedHeight():Number {
			var hh:Number = getStyle("headerHeight");
			if (hh <= 0 || isNaN(hh)) hh = titleBar.height;
			return hh;
		}
		// sets the correct title icon
		private function setTitleIcon():void
		{
			if (!_open) this.titleIcon = getStyle("closedIcon");
			else this.titleIcon = getStyle("openIcon");
		}
// BEGIN: public methods				------------------------------------------------------------
		/**
		* Collapses / expands this block (with animation)
		*/
		public function toggleOpen():void
		{
			if (!_openAnim.isPlaying) {
				_openAnim.fromValue = _openAnim.target.height;
				if (!_open) {
					_openAnim.toValue = openHeight;
					_open = true;
					dispatchEvent(new Event(Event.OPEN));
				}else{
					_openAnim.toValue = _openAnim.target.closedHeight;
					_open = false;
					dispatchEvent(new Event(Event.CLOSE));
				}
				setTitleIcon();
				_openAnim.play();
			}
		}
		/**
		* Whether the block is in a expanded (open) state or not
		*/
		public function get isOpen():Boolean {
			return _open;
		}
		/**
		* @private
		*/
		public function set isOpen(aValue:Boolean):void {
			_open = aValue;
		}
		/**
		* @private
		*/
		override public function invalidateSize():void {
			super.invalidateSize();
			if (_open && !_openAnim.isPlaying) this.height = openHeight;
		}
		
	}
}
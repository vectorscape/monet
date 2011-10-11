package com.velti.monet.controls.itemRenderers
{
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	/**
	 * Adds a checkbox to the item in a tree control
	 * @author Clint Modien
	 * 
	 */	
	public class TreeCheckBoxItemRenderer extends TreeItemRenderer
	{
		/**
		 * The checkbox to add 
		 */		
		public var chk:CheckBox;
		/**
		 * The data item as XML 
		 */		
		public var itemXml:XML;
		/**
		 * Constructor 
		 * 
		 */		
		public function TreeCheckBoxItemRenderer(){
			super();
			mouseEnabled = false;
		}
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set data(value:Object):void{
			if(value != null){
				super.data = value;
				
				this.itemXml = XML(value);
				if(this.itemXml.@checked == "1"){
					this.chk.selected = true;
					if(!this.itemXml.@origValue) this.itemXml.@origValue = "1";
				}else{
					this.chk.selected = false;
					this.itemXml.@origValue = "0";
					if(!this.itemXml.@origValue) this.itemXml.@origValue = "1";this.itemXml.@checked = "0";
				}
			}
		}
		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void{
			super.createChildren();
			chk = new CheckBox();
			chk.addEventListener(MouseEvent.CLICK, handleChkClick);
			addChild(chk);
		}
		/**
		 * @inheritDoc
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(super.data){
				var tld:TreeListData = TreeListData(super.listData);
				//In some cases you only want a checkbox to appear if an
				
				//item is a leaf
				//if so, then keep the following block uncommented,
				//otherwise you can comment it out to display the checkbox
				
				//for branch nodes
				if(tld.hasChildren){
					this.chk.visible = false;
				}else{
					//You HAVE to have the else case to set visible to true
					//even though you'd think the default would be visible
					//it's an issue with itemrenderers...
					this.chk.visible = true;
				}
				if(chk.visible){
					//if the checkbox is visible then
					//reposition the controls to make room for checkbox
					this.chk.x = super.label.x
					super.label.x = this.chk.x + 17;
					this.chk.y = super.label.y+8;
				}
			}
		}
		
		private function handleChkClick(event:MouseEvent):void{
			if(this.chk.selected){
				//this.checked = true;
				this.itemXml.@checked = "1";
			}else{
				//this.checked = false;
				this.itemXml.@checked = "0";
			}
			if(this.itemXml.@checked != this.itemXml.@origValue)
				this.itemXml.@wasEdited = "1";
			else 
				this.itemXml.@wasEdited = "0"
		}
	}
}
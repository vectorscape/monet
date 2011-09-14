package com.velti.monet.views.supportClasses {
	import com.velti.monet.models.Element;
	
	import mx.core.IUIComponent;
	
	/**
	 * Interface that the renderer class for a PlanDiagramBase
	 * must support.
	 * 
	 * @author Ian Serlin
	 */	
	public interface IElementRenderer extends IUIComponent {
		
		/**
		 * The data backing this visual component. 
		 */		
		function get element():Element;
		function set element( value:Element ):void;

		/**
		 * The id to represent this visual element, should
		 * return <code>this.element.uid</code>. 
		 */		
		function get elementUID():String;
	}
}
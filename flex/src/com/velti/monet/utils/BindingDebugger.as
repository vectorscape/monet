package com.velti.monet.utils
{
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	/**
	 * A class to wrap the BindingManager and focus
	 * on debugging a specific component.
	 * http://dodgybits.org/2009/04/12/flex-data-binding-pitfalls/
	 * @author Andy Bryant
	 * 
	 */	
	// Kudos to Cathal Golden for coming up with this technique
	public class BindingDebugger
	{
		
		private static const BINDINGS_PROPERTY : String =
			"_bindingsByDestination";
		/**
		 * Focuses the BindingManager on debuggon a specific component. 
		 * @param displayObject The dispaly object to debug. 
		 * @param recursive Whether to debug all the displayObjects child displayObjects in the display object hierarchy.
		 * 
		 */		
		public static function debugComponent (
			displayObject : Object, recursive : Boolean = true) : void // NO PMD
		{
			if (displayObject is IBindingClient)
			{
				var bindings : Object = displayObject[ BINDINGS_PROPERTY ]; // NO PMD
				for ( var binding : String in bindings )
				{
					BindingManager.debugBinding(binding);
				}
			}
			
			if (recursive && displayObject is UIComponent)
			{
				var component : UIComponent = UIComponent( displayObject );
				for (var i : int = 0; i < component.numChildren; i++)
				{
					debugComponent(component.getChildAt(i), true);
				}
			}
		}
	}
}

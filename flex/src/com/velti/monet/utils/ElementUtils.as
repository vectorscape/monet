package com.velti.monet.utils {
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	
	/**
	 * Static class to help with manipulating Elements.
	 * 
	 * @author Ian Serlin
	 */
	public class ElementUtils {
		
		/**
		 * Determines if the given a element is logically ordered
		 * before the b element in the a campaign plan.
		 * 
		 * @param a
		 * @param b
		 * 
		 * @return 1 if b should be before a, -1 if a should be before b, and 0 if they are logically at the same level
		 */		
		public static function sortElementsByType( a:Element, b:Element ):int {
			var order:int = 0;
			var aPosition:int;
			var bPosition:int;
			var i:int;
			
			for( i = 0; i < ElementType.ELEMENT_ORDER.length; i++ ){
				if( ElementType.ELEMENT_ORDER[ i ] == a.type ){
					aPosition = i;
					break;
				}
			}
			
			for( i = 0; i < ElementType.ELEMENT_ORDER.length; i++ ){
				if( ElementType.ELEMENT_ORDER[ i ] == b.type ){
					bPosition = i;
					break;
				}
			}
			
			if( aPosition < bPosition ){
				order = -1;
			}else if( bPosition < aPosition ){
				order = 1;
			}
			
			return order;
		}
		
		/**
		 * Links two elements together in a parent-child relationship.
		 * 
		 * @param parentElement
		 * @param childElement
		 */		
		public static function linkElements( parentElement:Element, childElement:Element ):void {
			parentElement.descendents.add( childElement );
			childElement.parents.add( parentElement );
		}
		
		/**
		 * Unlinks two elements together in a parent-child relationship.
		 * 
		 * @param parentElement
		 * @param childElement
		 */		
		public static function unlinkElements( parentElement:Element, childElement:Element ):void {
			if( parentElement.descendents.containsElement( childElement ) ){
				parentElement.descendents.remove( childElement );
			}
			
			if( childElement.parents.containsElement( parentElement ) ){
				childElement.parents.remove( parentElement );
			}			
		}
		
	}
}
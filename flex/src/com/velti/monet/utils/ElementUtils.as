package com.velti.monet.utils {
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.elementData.InteractionElementData;
	
	/**
	 * Static class to help with manipulating Elements.
	 * 
	 * @author Ian Serlin
	 */
	public class ElementUtils {
		
		/**
		 * Simplistic method of determining whether two
		 * Elements are logically equivalent and not null.
		 * 
		 * The initial use for this is "pivoting".
		 * 
		 * @param a first element you want to compare
		 * @param b second element you want to compare
		 * @return 
		 */		
		public static function isEqual( a:Element, b:Element ):Boolean {
			return a && b && a.type == b.type && a.label == b.label;
		}

		/**
		 * Simplistic method that tests if an element is "blank" or not.
		 * 
		 * @param element the element you want to know is blank or not
		 * @return true if the element is considered to be blank, false otherwise 
		 */		
		public static function isBlank( element:Element ):Boolean {
			var blank:Boolean = element == null;
			// for interactions, it's not blank if it has descendents
			// or its interactionType is set
			if( element && element.type == ElementType.INTERACTION ){
				if( element.descendents.length < 1
					&& ( !element.data
					|| !(element.data is InteractionElementData)
					|| (element.data as InteractionElementData).type == null ) ){
					blank = true;
				}
			}
			return blank;
		}
		
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
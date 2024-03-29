package com.velti.monet.utils {
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.elementData.AdvertisementElementData;
	import com.velti.monet.models.elementData.InteractionElementData;
	
	/**
	 * Static class to help with manipulating Elements.
	 * 
	 * @author Ian Serlin
	 */
	public class ElementUtils {
		
		/**
		 * Duplicates a given element and returns the duplicate.
		 * 
		 * @param element the element you want to duplicate
		 * @return the duplicated element (and its duplicated descendents)
		 */		
		public static function duplicate( element:Element ):Element {
			var dupe:Element = new Element( element.type, element.label );
			dupe.data = element.data.duplicate();
			var associatedElement:Element;
			for each( associatedElement in element.descendents ){
				dupe.descendents.add( ElementUtils.duplicate( associatedElement ) );
			}
			return dupe;
		}
		
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
			if( !element ){ return true; }
			
			var blank:Boolean = false;
			// for interactions, it's not blank if it has descendents
			// or its interactionType is set
			switch( element.type ){
				case ElementType.INTERACTION:
					if( element.descendents.length < 1
						&& ( !element.data
							|| !(element.data is InteractionElementData)
							|| (element.data as InteractionElementData).type == null ) ){
						blank = true;
					}
					break;
				case ElementType.ADVERTISEMENT:
					if( element.data 
						&& element.data is AdvertisementElementData
						&& (element.data as AdvertisementElementData).type ){
						blank = false;
					}else if( element.descendents == null || element.descendents.length == 0 ){
						blank = true;
					}else{
						for( var i:int = 0; i < element.descendents.length; i++ ){
							blank = isBlank( element.descendents.getAt( i ) );
							if( blank ){
								break;
							}
						}
					}			
					break;
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
		 * Duplicates the connections from one element to another.
		 * 
		 * @param origin element whose connections you want to copy
		 * @param destination element whose connections you want to copy to
		 */		
		public static function copyConnections( origin:Element, destination:Element ):void {
			if( origin && destination ){
				var i:int;
				for( i = 0; i < origin.descendents.length; i++ ){
					destination.descendents.add( origin.descendents.getAt( i ) );
				}
				for( i = 0; i < origin.parents.length; i++ ){
					destination.parents.add( origin.parents.getAt( i ) );
				}
			}
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
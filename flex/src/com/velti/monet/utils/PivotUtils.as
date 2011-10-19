package com.velti.monet.utils {
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.models.Element;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * A static set of helper functions
	 * for supporting the "pivot" operation
	 * of the application.
	 *  
	 * @author Ian Serlin
	 */	
	public class PivotUtils {
		
		/**
		 * Searches through a set of elements to build up and return the sub-set
		 * that are "equivalent" to the given original element. This function uses
		 * the <code>ElementUtils.isEqual</code> method.
		 * 
		 * @param originalElement The element you want to find "matches" for
		 * @param elements The set of elements you want to look for matches in
		 * @return An array of "equivalent" elements, including the original element if it is present in the collection 
		 */		
		public static function getEquivalentElements( originalElement:Element, elements:ArrayCollection ):Array {
			var pivotElements:Array = [];
			for each( var potentialMatch:Element in elements ){
				if( ElementUtils.isEqual( originalElement, potentialMatch ) ){
					pivotElements.push( potentialMatch );
				}
			}
			return pivotElements;
		}
		
		/**
		 * Walks the element graph of the given pivotElements and creates an IndexedCollection
		 * containing all the direct descendents and parents of those pivot elements. 
		 * 
		 * @param pivotElements The elements you want to pivot on
		 * @return An IndexedCollection of elements that should be shown while pivoting, given the inputs 
		 */		
		public static function getRelevantElementsForPivoting( pivotElements:Array ):IndexedCollection {
			var relevantElements:IndexedCollection = new IndexedCollection("elementID");
			if( pivotElements ){
				var stack:Array = pivotElements.concat();
				var element:Element;
				
				// 1. add all descendents of pivot elements
				while( stack.length > 0 ){
					element = stack.shift() as Element;
					if( element ){
						stack = stack.concat( element.descendents.toArray() );
						relevantElements.addItem( element );
					}
				}
				
				// 2. add all direct parents of pivot elements
				stack = pivotElements;
				while( stack.length > 0 ){
					element = stack.shift() as Element;
					if( element ){
						stack = stack.concat( element.parents.toArray() );
						relevantElements.addItem( element );
					}
				}
			}
			return relevantElements;
		}
		
		
	}
}
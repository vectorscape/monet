package com.velti.monet.collections {
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	/**
	 * An extension of ArrayCollection to allow
	 * constant time lookup of elements by a particular
	 * property, like a Dictionary.
	 *
	 * @author Ian Serlin
	 */  
	public class IndexedCollection extends ArrayCollection {
		
		/**
		 * The property name of the items in the collection that
		 * you want to index the collection on.
		 */    
		public function set indexedProperty( value:String ):void {
			if( _indexedProperty != value ){
				_indexedProperty = value;
				invalidateIndex();
			}
		}
		public function get indexedProperty():String {
			return _indexedProperty;
		}
		/**
		 * @private
		 */    
		protected var _indexedProperty:String;
		
		/**
		 * The storage mechanism for indexing the items in
		 * the collection.
		 */    
		protected var _lookupIndex:Dictionary = null;
		
		protected function get lookupIndex():Dictionary {
			if(isIndexInvalid) {
				_lookupIndex = recalculateIndex();
			}
			
			return _lookupIndex;
		}
		
		/**
		 * Recreates the index used to do constant
		 * time lookups on this collection.
		 */    
		protected function recalculateIndex():Dictionary {
			const res:Dictionary = new Dictionary(true);
			if( _indexedProperty != null && _indexedProperty != '' ) {
				var item:Object; // NO PMD
				for(var i:int = 0; i < length; i++) {
					item = getItemAt(i);
					res[ item[_indexedProperty]] = item;
				}
			}
			
			return res;
		}
		
		/**
		 * marks local index as invalid
		 * the index is going to be recalculated next time it is required (example: getItemByIndex)
		 **/
		public function invalidateIndex():void 
		{
			_lookupIndex = null;
		}
		/**
		 * Whether the index is invalid or not.
		 */		
		public function get isIndexInvalid():Boolean {
			return _lookupIndex == null;
		}
		
		/**
		 * Retrieves an item in the collection whose
		 * <code>indexedProperty</code> matches the
		 * given key, if it exists. If the key is
		 * non-unique across the collection, it is
		 * indeterministic which item will be returned.
		 *
		 * @param key The value of the indexedProperty for
		 *            the item you want to retrieve.
		 * @return The requested item, if it exists, null otherwise.
		 */    
		public function getItemByIndex( key:Object ):Object { // NO PMD
			return (key != null) ? lookupIndex[ key ] : null;
		}
		
		/**
		 * Replaces an item currently in the collection that
		 * has a matching value for <code>indexedProperty</code>
		 * and returns the replaced item if a replace was performed.
		 * If no item currently had a matching <code>indexedProperty</code>
		 * value the given item is simply added to the collection.
		 *
		 * @param item The item you want to replace the existing item in the collection with.
		 * @return The item that was replaced, or null if no item was replaced.
		 */    
		public function setItemByIndex( item:Object ):Object { // NO PMD
			var replacedObject:Object = null; // NO PMD
			if( _indexedProperty != null && _indexedProperty != '' && lookupIndex[ item[ _indexedProperty ] ] ){
				replacedObject = lookupIndex[ item[ _indexedProperty ] ];
				var itemIndex:int = this.getItemIndex( replacedObject );
				if( itemIndex != -1 ){
					this.setItemAt( item, itemIndex );
				}else{
					this.addItem( item );
				}
			}else{
				this.addItem( item );
			}
			return replacedObject;
		}
		
		/**
		 * Removes an item currently in the collection that
		 * has the passed in value for its <code>indexedProperty</code>.
		 * 
		 * @param key The value of the indexedProperty for
		 *            the item you want to remove.
		 * @return The item that was removed, or null if no item was removed.
		 */    
		public function removeItemByIndex( key:Object ):Object {// NO PMD
			var removedItem:Object = getItemByIndex( key );// NO PMD
			if( removedItem ){
				this.removeItemAt( this.getItemIndex( removedItem ) );
			}
			return removedItem;
		}
		
		/**
		 * @inheritDoc
		 *
		 * Overridden to support indexing by property.
		 */    
		override public function addItemAt( item:Object, index:int ):void {
			var existingItem:Object = null;
			if( _indexedProperty != null && _indexedProperty != '' ){ 
				if( lookupIndex[ item[ _indexedProperty ] ] != null ){
					existingItem = lookupIndex[ item[ _indexedProperty ] ];
				}
				lookupIndex[ item[ _indexedProperty ] ] = item;
			}
			if( !this.contains( item ) ){
				if( existingItem ){
					super.setItemAt( item, getItemIndex( existingItem ) );
				}else{
					super.addItemAt( item, index );
				}
			}
		}
		
		/**
		 * @inheritDoc
		 *
		 * Overridden to support indexing by property.
		 */       
		override public function setItemAt( item:Object, index:int ):Object {// NO PMD
			if( _indexedProperty != null && _indexedProperty != '' ){
				lookupIndex[ item[ _indexedProperty ] ] = item;
			}
			if( !this.contains( item ) ){
				return super.setItemAt( item, index );
			}else{
				return item;
			}
		}
		
		/**
		 * @inheritDoc
		 *
		 * Overridden to remove this item from the index as well.
		 */    
		override public function removeAll():void {
			super.removeAll();
			invalidateIndex();
		}
		
		/**
		 * @inheritDoc
		 *
		 * Overridden to remove this item from the index as well.
		 */    
		override public function removeItemAt( index:int ):Object {// NO PMD
			var removedItem:Object = super.removeItemAt( index );// NO PMD
			if( _indexedProperty != null && _indexedProperty != '' && _lookupIndex != null ){
				delete _lookupIndex[ removedItem[ _indexedProperty ] ];
			}
			return removedItem;
		}
		
		/**
		 * @inheritDoc
		 *
		 * Setting the source on the ArrayCollection will also refresh the index
		 */       
		override public function set source( value:Array ):void {
			if( !value ){
				removeAll();
			}else{
				super.source = value;
			}
			invalidateIndex();
		}
		
		// ================== Constructor ==================
		
		/**
		 * Constructor 
		 * 
		 * @param indexedProperty (optional) The property name of the items in the collection that
		 *                        you want to index the collection on.
		 * @param source An array you want the collection to be initialized with, if any.
		 */    
		public function IndexedCollection( indexedProperty:String=null, source:Array=null ) {
			super(source || []);
			this.indexedProperty = indexedProperty;
		}
		
	}
}


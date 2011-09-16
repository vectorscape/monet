package com.velti.monet.models 
{
	import com.velti.monet.collections.IndexedCollection;
	import com.velti.monet.utils.PlanUtils;
	
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ListCollectionView;
	import mx.utils.ObjectUtil;
	
	/**
	 * Model that represents an entire plan as a whole.
	 * It is an adjacency list representing a directed graph.
	 * 
	 * @author Ian Serlin
	 */
	[RemoteClass]
	public class Plan extends IndexedCollection implements ISerializable, ICloneable 
	{	
		/**
		 * @private 
		 */		
		private var _audiences:ListCollectionView;
		/**
		 * Collection of audiences represented by this plan. 
		 */		
		public function get audiences():ListCollectionView {
			return _audiences;
		}
		
		/**
		 * @private 
		 */		
		private var _campaigns:ListCollectionView;
		/**
		 * Collection of plans represented by this plan. 
		 */		
		public function get campaigns():ListCollectionView {
			return _campaigns;
		}
		
		/**
		 * Constructor.
		 * 
		 * Creates a new Plan containing
		 * the default set of elements. 
		 */		
		public function Plan() {
			super("elementID");
			
			//register the class alias so 
			//we can serialize deserialze from AMF
			var classAlias:String = getQualifiedClassName(this);
			var def:Class = getDefinitionByName(classAlias) as Class;
			registerClassAlias(classAlias,def);
			
			_audiences = new ListCollectionView( this );
			_audiences.filterFunction = PlanUtils.filterAudiencesOnly;
			_audiences.refresh();
			
			classAlias = getQualifiedClassName(_audiences);
			def = getDefinitionByName(classAlias) as Class;
			registerClassAlias(classAlias,def);
			
			_campaigns = new ListCollectionView( this );
			_campaigns.filterFunction = PlanUtils.filterPlansOnly;
			_campaigns.refresh();
			
			classAlias = getQualifiedClassName(_campaigns);
			def = getDefinitionByName(classAlias) as Class;
			registerClassAlias(classAlias,def);
		}
		
		/**
		 * Overriden to always set the default. 
		 */		
		override public function set indexedProperty(value:String):void {
			super.indexedProperty = "elementID";
		}

		/**
		 * Retrieves an array of the elements which are direct next-level descendents
		 * of the given element.
		 * 
		 * @param element The Element whose descendent Element instances you want
		 * @return an array of elements that are the direct next-level descendents of the give element 
		 */		
		public function getDescendentElementsOfElement( element:Element ):Array {
			var elements:Array = [];
			var descendentElement:Element;
			for each( var elementID:String in element.descendents ){
				descendentElement = this.getItemByIndex( elementID ) as Element;
				if( descendentElement ){
					elements.push( descendentElement );
				}
			}
			return elements;
		}
		
		/**
		 * Retrieves an array of the elements which are direct previous-level parent
		 * of the given element.
		 * 
		 * @param element The Element whose parent Element instances you want
		 * @return an array of elements that are the direct previous-level parents of the give element 
		 */		
		public function getParentElementsOfElement( element:Element ):Array {
			var elements:Array = [];
			var parentElement:Element;
			for each( var elementID:String in element.parents ){
				parentElement = this.getItemByIndex( elementID ) as Element;
				if( parentElement ){
					elements.push( parentElement );
				}
			}
			return elements;
		}

		public function clone():Object
		{
			return ObjectUtil.copy(this);
		}
	}
}
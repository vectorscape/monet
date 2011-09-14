package com.velti.monet.utils {
	import com.velti.monet.models.Audience;
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Plan;
	
	/**
	 * Set of utility methods for manipulating
	 * <code>com.velti.monet.models.Plan</code>s.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanUtils {
		
		/**
		 * Filter function to use when you want to filter out everything
		 * but Campaign elements in a plan collection. 
		 *  
		 * @param item
		 * @return 
		 */		
		public static function filterCampaignsOnly( item:Element ):Boolean {
			return item && item is Campaign;
		}
		
		/**
		 * Filter function to use when you want to filter out everything
		 * but Audience elements in a plan collection. 
		 *  
		 * @param item
		 * @return 
		 */		
		public static function filterAudiencesOnly( item:Element ):Boolean {
			return item && item is Audience;
		}
		
		/**
		 * Finds the maximum number of elements at any given level of a branch
		 * specified by the given set of elementIDs.
		 * 
		 * @param elementIDs the set of ids representing the elements at a given level of a branch
		 * @param plan the plan containing the branch you are measuring
		 * @return the maximum number of elements at any given level of this branch
		 */		
		public static function measureWidthOfBranch( elementIDs:Array, plan:Plan ):int {
			if( !plan ){
				throw new Error("PlanUtils::measureWidthOfBranch must be provided a corresponding plan.");
			}
			
			var maxWidthOfBranch:int = 0;
			if( elementIDs && elementIDs.length > 0 ){
				// this level of the branch might have the most elements
				maxWidthOfBranch = elementIDs.length;
				trace( 'this branch has a width of: ' + maxWidthOfBranch );
				// check the width of sub-branches
				var elementsToCheck:Array = [];
				var element:Element;
				for each( var elementID:String in elementIDs ){
					element = plan.getItemByIndex( elementID ) as Element;
					elementsToCheck = elementsToCheck.concat( element.descendents.toArray() );
				}
				var widthOfSubBranches:int = measureWidthOfBranch( elementsToCheck, plan );
				if( widthOfSubBranches > maxWidthOfBranch ){
					maxWidthOfBranch = widthOfSubBranches;
					trace( 'updating to width of sub-branch: ' + maxWidthOfBranch );
				}

			}
			return maxWidthOfBranch;
		}
		
	}
}
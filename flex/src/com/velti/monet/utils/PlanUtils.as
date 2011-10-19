package com.velti.monet.utils {
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	
	/**
	 * Set of utility methods for manipulating
	 * <code>com.velti.monet.models.Plan</code>s.
	 * 
	 * @author Ian Serlin
	 */	
	public class PlanUtils {
		
		/**
		 * Filter function to use when you want to filter out everything
		 * but Plan elements in a plan collection. 
		 *  
		 * @param item
		 * @return 
		 */		
		public static function filterCampaignsOnly( item:Element ):Boolean {
			return item && item is Element && (item as Element).type == ElementType.CAMPAIGN;
		}
		
		/**
		 * Filter function to use when you want to filter out everything
		 * but Audience elements in a plan collection. 
		 *  
		 * @param item
		 * @return 
		 */		
		public static function filterAudiencesOnly( item:Element ):Boolean {
			return item && item is Element && (item as Element).type == ElementType.AUDIENCE;
		}
	}
}
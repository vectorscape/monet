package com.velti.monet.utils
{
	import com.velti.monet.models.Advertisement;
	import com.velti.monet.models.Audience;
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Placement;
	import com.velti.monet.models.Publisher;

	/**
	 * Helper functions for dealing with resource bundles.
	 */	
	public class ResourceUtils
	{
		/**
		 * Returns the label key to use to lookup the default label based on the
		 * type of element passed in
		 * 
		 * @param the element you want to retrieve the default label key for
		 * 
		 * @returns the default label key, if any
		 */
		public static function getDefaultLabelElementType( element:Element ):String {
			var labelKey:String;
			if( element is Campaign ){
				labelKey = "campaign";
			}else if( element is Audience ){
				labelKey = "audience";
			}else if( element is Publisher ){
				labelKey = "publisher";
			}else if( element is Placement ){
				labelKey = "placement";
			}else if( element is Advertisement ){
				labelKey = "advertisement";
			}else if( element
		}
	}
}
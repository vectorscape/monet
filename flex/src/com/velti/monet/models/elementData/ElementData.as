package com.velti.monet.models.elementData
{
	import com.velti.monet.models.DataObject;
	import com.velti.monet.models.ElementType;

	public class ElementData extends DataObject
	{	
		public static const NO_ELEMENT_DATA:ElementData = new ElementData();
		
		public function ElementData() {
			super();
			
		}
		
		public function get labelString():String {
			//override in base class
			return _labelString;
		} public function set labelString(v:String):void {
			//override in base class
			_labelString = v;
		} private var _labelString:String;
		
		public function get isValid():Boolean {
			//override in base class
			return false;
		}
		
		public static function getDataForType(v:ElementType):ElementData {
			var returnVal:ElementData;
			switch (v) {
				case ElementType.CAMPAIGN :
					returnVal = new CampaignElementData();
					break;
				case ElementType.AUDIENCE :
					returnVal = new AudienceElementData();
					break;
				case ElementType.PUBLISHER :
					returnVal = new PublisherElementData();
					break;
				case ElementType.PLACEMENT :
					returnVal = new PlacementElementData();
					break;
				case ElementType.ADVERTISEMENT :
					returnVal = new AdvertisementElementData();
					break;
				case ElementType.INTERACTION :
					returnVal = new InteractionElementData();
					break;
				case ElementType.KEY :
					returnVal = new KeyElementData();
					break;
				default:
					returnVal = NO_ELEMENT_DATA;
					break;
			}
			return returnVal;
		}
	}
}
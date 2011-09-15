package com.velti.monet.models.elementData
{
	import com.velti.monet.models.ElementType;

	public class ElementData
	{
		public function ElementData() {
			
		}
		
		public static function getDataForType(v:ElementType):ElementData {
			var returnVal:ElementData;
			switch (v) {
				case ElementType.CAMPAIGN :
					returnVal new CampaignElementData();
					break;
				case ElementType.AUDIENCE :
					returnVal new AudienceElementData();
					break;
				case ElementType.PUBLISHER :
					returnVal new PublisherElementData();
					break;
				case ElementType.PLACEMENT :
					returnVal new PlacementElementData();
					break;
				case ElementType.ADVERTISEMENT :
					returnVal new AdvertisementElementData();
					break;
				case ElementType.INTERACTION :
					returnVal new InteractionElementData();
					break;
				default:
					trace("getDataForType: element type not handled");
					break;
			}
			return returnVal;
		}
	}
}
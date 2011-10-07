package assetsEmbedded.advertisements
{
	/**
	 * Static Asset Library
	 * 
	 * @author Ian Serlin
	 */	
	public class AdvertisementAssets {
		
		[Embed(source="/assetsEmbedded/advertisements/audio.png")] // NO PMD
		public static const INTERACTION_AUDIO:Class;
		
		[Embed(source="/assetsEmbedded/advertisements/banner.png")] // NO PMD
		public static const INTERACTION_BANNER:Class;
		
		[Embed(source="/assetsEmbedded/advertisements/rich_media.png")] // NO PMD
		public static const INTERACTION_RICH_MEDIA:Class;
		
		[Embed(source="/assetsEmbedded/advertisements/text.png")] // NO PMD
		public static const INTERACTION_TEXT:Class;
		
		[Embed(source="/assetsEmbedded/advertisements/video.png")] // NO PMD
		public static const INTERACTION_VIDEO:Class;
		
	}
}
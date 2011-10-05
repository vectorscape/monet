package
{
	/**
	 * Static Asset Library
	 * 
	 * @author Ian Serlin
	 */	
	public class AdvertisementAssets {
		
		[Embed(source="assets-embedded/audio.png")]
		public static const INTERACTION_AUDIO:Class;
		
		[Embed(source="assets-embedded/banner.png")]
		public static const INTERACTION_BANNER:Class;
		
		[Embed(source="assets-embedded/rich_media.png")]
		public static const INTERACTION_RICH_MEDIA:Class;
		
		[Embed(source="assets-embedded/text.png")]
		public static const INTERACTION_TEXT:Class;
		
		[Embed(source="assets-embedded/video.png")]
		public static const INTERACTION_VIDEO:Class;
		
	}
}
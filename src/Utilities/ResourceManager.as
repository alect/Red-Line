package Utilities
{
	public class ResourceManager
	{
		
		//Graphics
		[Embed(source="assets/art/floor-tiles.png")]
		public static var floorMapArt:Class;
		
		[Embed(source="assets/art/traintracks.png")]
		public static var trainTrackArt:Class;
		
		
		//Levels 
		[Embed(source="assets/levels/testlevel.oel", mimeType="application/octet-stream")]
		public static var testLevel:Class;
		
		[Embed(source="assets/levels/testlevel2.oel", mimeType="application/octet-stream")]
		public static var testLevel2:Class;
		
		//the array of levels. 
		public static var levelList:Array = [testLevel, testLevel2];
	}
}
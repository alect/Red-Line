package Utilities
{
	public class ResourceManager
	{
		
		//Graphics
		[Embed(source="assets/art/floor-tiles.png")]
		public static var floorMapArt:Class;
		
		[Embed(source="assets/art/traintracks.png")]
		public static var trainTrackArt:Class;
		
		[Embed(source="assets/art/player.png")]
		public static var playerArt:Class;
		
		[Embed(source="assets/art/agent.png")]
		public static var agentArt:Class;
		
		[Embed(source="assets/art/train.png")]
		public static var trainArt:Class;
		
		[Embed(source="assets/art/traindoor.png")]
		public static var trainDoorArt:Class;
		
		//Levels 
		[Embed(source="assets/levels/testlevel.oel", mimeType="application/octet-stream")]
		public static var testLevel:Class;
		
		[Embed(source="assets/levels/testlevel2.oel", mimeType="application/octet-stream")]
		public static var testLevel2:Class;
		
		//the array of levels. 
		public static var levelList:Array = [testLevel, testLevel2];
	}
}
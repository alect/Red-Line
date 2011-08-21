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
		
		[Embed(source="assets/art/commuter.png")]
		public static var commuterArt:Class;
		
		//Levels 
		[Embed(source="assets/levels/testlevel.oel", mimeType="application/octet-stream")]
		public static var testLevel:Class;
		
		[Embed(source="assets/levels/testlevel2.oel", mimeType="application/octet-stream")]
		public static var testLevel2:Class;
		
		[Embed(source="assets/levels/testcommuters.oel", mimeType="application/octet-stream")]
		public static var level6:Class;
		
		[Embed(source="assets/levels/verticaltest.oel", mimeType="application/octet-stream")]
		public static var verticalTest:Class;
		
		[Embed(source="assets/levels/level1.oel", mimeType="application/octet-stream")]
		public static var level1:Class;
		
		[Embed(source="assets/levels/level2.oel", mimeType="application/octet-stream")]
		public static var level2:Class;
		
		[Embed(source="assets/levels/level3.oel", mimeType="application/octet-stream")]
		public static var level3:Class;
		
		[Embed(source="assets/levels/level4.oel", mimeType="application/octet-stream")]
		public static var level4:Class;
		
		[Embed(source="assets/levels/level5.oel", mimeType="application/octet-stream")]
		public static var level5:Class;
		
		[Embed(source="assets/levels/level7.oel", mimeType="application/octet-stream")]
		public static var level7:Class;
		
		[Embed(source="assets/levels/level8.oel", mimeType="application/octet-stream")]
		public static var level8:Class;
		
		[Embed(source="assets/levels/level9.oel", mimeType="application/octet-stream")]
		public static var level9:Class;
		
		[Embed(source="assets/levels/level10.oel", mimeType="application/octet-stream")]
		public static var level10:Class;
		
		//the array of levels. 
		public static var levelList:Array = [level10, level9, level8, level7, verticalTest, level1, level2, level3, level5, level4, level6, testLevel, testLevel2];
	}
}
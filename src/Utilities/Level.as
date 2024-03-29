package Utilities
{
	import org.flixel.FlxPoint;

	/**
	 * A simple container to store our level information. Create by a call to loadLevel in LevelLoader
	 */
	public class Level
	{
		//The CSV we use to build the tilemap
		public var gridCSV:String;
		
		//Where the player begins the level
		public var playerStartLocation:FlxPoint;
		
		//A list of FBI agents to spawn in the level
		public var agentLocations:Array;
		
		//A list of the left moving commuters in the level
		public var leftCommuters:Array;
		
		//A list of the right moving commuters in the level
		public var rightCommuters:Array;
		
		//A list of the vertical moving commuters in the level. 
		public var verticalCommuters:Array;
		
		
		public function Level()
		{
		}
	}
}
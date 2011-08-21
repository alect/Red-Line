package Utilities
{
	import flash.utils.ByteArray;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	public class LevelLoader
	{

			
			/**
			 * Function that takes XML data (from the OGMO editor)
			 * and turns it into a Level object from which we an start a level. 
			 */
			public static function loadLevel(xml:Class):Level
			{
				var rawData:ByteArray = new xml;
				var dataString:String = rawData.readUTFBytes(rawData.length);
				var xmlData:XML = new XML(dataString);
				
				var dataList:XMLList;
				var dataElement:XML;
				dataList = xmlData.grid.tile;
				
				//first, initialize our grid array which we use to create the tilemap CSV later
				var tileArray:Array = [];
				for(var i:int = 0; i < Math.floor(FlxG.width/Globals.GRID_CELL_SIZE); i++)
				{
					var column:Array = [];
					for(var j:int = 0; j < Math.floor((FlxG.height-70)/Globals.GRID_CELL_SIZE); j++)
						column.push(0);
					tileArray.push(column);
				}
				
				var levelToReturn:Level = new Level();
				levelToReturn.agentLocations = [];
				levelToReturn.leftCommuters = [];
				levelToReturn.rightCommuters = [];
				
				//now grab all the data tiles
				for each(dataElement in dataList)
				{
					var canonicalX:int = dataElement.@x / Globals.GRID_CELL_SIZE;
					var canonicalY:int = dataElement.@y / Globals.GRID_CELL_SIZE;
					
					if (dataElement.@tx == 0 && dataElement.@ty == 0) 
					{
						tileArray[canonicalX][canonicalY] = 1; // Place a wall
					}
					if (dataElement.@tx == 10 && dataElement.@ty == 0)
					{
						// player start location
						levelToReturn.playerStartLocation = new FlxPoint(canonicalX*Globals.GRID_CELL_SIZE, canonicalY*Globals.GRID_CELL_SIZE);	
					}
					if(dataElement.@tx == 20 && dataElement.@ty == 0)
					{
						levelToReturn.agentLocations.push(new FlxPoint(canonicalX*Globals.GRID_CELL_SIZE, canonicalY*Globals.GRID_CELL_SIZE));
					}
					if(dataElement.@tx == 30 && dataElement.@ty == 0)
					{
						//a right facing commuter
						levelToReturn.rightCommuters.push(new FlxPoint(canonicalX*Globals.GRID_CELL_SIZE, canonicalY*Globals.GRID_CELL_SIZE));
					}
					if(dataElement.@tx == 30 && dataElement.@ty == 10)
					{
						//a left facing commuter
						levelToReturn.leftCommuters.push(new FlxPoint(canonicalX*Globals.GRID_CELL_SIZE, canonicalY*Globals.GRID_CELL_SIZE));
					}
				}
				
				//finally, we need to turn our array into a CSV so it can be easily parsed by Flxtilemap
				levelToReturn.gridCSV = arrayToCSV(tileArray);
				
				return levelToReturn;
			}
			
			private static function arrayToCSV(array:Array):String
			{
				var csv:String = "";
				//need to scan through row by row
				for(var j:int = 0; j < array[0].length; j++)
				{
					for(var i:int = 0; i < array.length; i++)
					{
						csv += (array[i][j] as int).toString() + ((i < array.length-1)?",":"\n");
					}
				}
				return csv;
			}
			
	}
}
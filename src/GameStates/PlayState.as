package GameStates
{
	import GameObjects.Player;
	
	import Utilities.*;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState
	{
		//the player character in this instance. 
		private var _player:Player;
		
		
		public override function create():void
		{
			_player = new Player(22, 22);
			this.add(_player);
			
			var simpleMap:Array = [];
			for(var i:int = 0; i < 32; i++)
			{
				var column:Array = [];
				
				for(var j:int = 0; j < 24; j++)
				{
					column.push(0);
				}
				
				simpleMap.push(column);
			}
			
			
			var playerGridPos:FlxPoint = new FlxPoint(Math.floor(_player.x/Globals.GRID_CELL_SIZE), Math.floor(_player.y/Globals.GRID_CELL_SIZE));
			var fbiPos:FlxPoint = new FlxPoint(0, 0);
			
			var fbiPath:Array = AStar.A_Star(fbiPos, playerGridPos, simpleMap, 32, 24);
			for each(var node:FlxPoint in fbiPath)
				trace(node);
			
		}
	}
}
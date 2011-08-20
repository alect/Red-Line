package GameObjects
{
	import Utilities.*;
	
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	
	public class FBIAgent extends FlxSprite
	{
		//A constant that represents how many tiles away from the player we should be at all times. 
		//used basically by having removing the last x nodes from our A* path
		private static const MIN_DIS_TO_PLAYER:int = 3;
		
		//A constant used to tell when to start following the player. Basically the euclidean distance required before we start following the player. 
		private static const MAX_DIS_TO_PLAYER:Number = 50;
		
		//the speed we follow the player at
		private static const WALK_SPEED:Number = 80;
		
		//looks like I'll at least need a variable to tell if we're following the player
		private var _followingPlayer:Boolean = false;
		private var _player:Player;
		
		//And it looks like we'll need a reference to the floor map so we can perform proper A*
		private var _map:FlxTilemap;
		
		
		public function FBIAgent(x:Number, y:Number, playerToFollow:Player, floorMap:FlxTilemap)
		{
			super(x, y);
			this.makeGraphic(10, 10, 0xffff0000);
			_player = playerToFollow;
			_map = floorMap;
		}
		
		public override function update():void
		{
			super.update();
			
			//Since we should only be moving via paths, if our path becomes 0, we should really stop moving. 
			if(pathSpeed == 0)
			{
				this.velocity = new FlxPoint();
				_followingPlayer = false;
			}
			if(!_followingPlayer && Math.sqrt(Math.pow(this.x-_player.x, 2)+Math.pow(this.y-_player.y, 2)) > MAX_DIS_TO_PLAYER)
				followPlayer();
			
			
		}
		
		private function followPlayer():void
		{
			var startPoint:FlxPoint = new FlxPoint(Math.floor(this.x/Globals.GRID_CELL_SIZE), Math.floor(this.y/Globals.GRID_CELL_SIZE));
			var destPoint:FlxPoint = new FlxPoint(Math.floor(_player.x/Globals.GRID_CELL_SIZE), Math.floor(_player.y/Globals.GRID_CELL_SIZE));
			var map:Array = createAStarMap();
			var columns:int = map.length;
			var rows:int = map[0].length;
			
			var path:Array = AStar.A_Star(startPoint, destPoint, map, columns, rows);
			//If our path is too small, then don't follow the player
			if(path.length <= MIN_DIS_TO_PLAYER)
				return;
			
			//otherwise, go ahead and truncate the path
			path.splice(path.length-MIN_DIS_TO_PLAYER, MIN_DIS_TO_PLAYER);
			
			//And follow it!
			this.followPath(new FlxPath(path), WALK_SPEED);
			
			_followingPlayer = true;
		}
		
		//A simple function to create the map for A_Star
		//It's highly likely this will become more complicated as more features are added. 
		//For now, let's just make an empty map. 
		private function createAStarMap():Array
		{
			//Since we've got the rail line to care about, let's go ahead and say that the top part of the screen is off limits
			var simpleMap:Array = [];
			for(var i:int = 0; i < _map.widthInTiles; i++)
			{
				var column:Array = [];
				
				
				for(var j:int = 0; j < Math.floor(FlxG.height/Globals.GRID_CELL_SIZE); j++)
				{
					//if we're below the start of the tilemap, pretend there's a wall there. 
					if(j < Math.floor(_map.y/Globals.GRID_CELL_SIZE))
						column.push(1);
					else
						column.push(_map.getTile(i, j-Math.floor(_map.y/Globals.GRID_CELL_SIZE)));
				}
				
				simpleMap.push(column);
			}
			return simpleMap;
		}
	}
}
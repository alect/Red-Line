package GameObjects
{
	import GameStates.PlayState;
	
	import Utilities.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	public class FBIAgent extends FlxSprite
	{
		//A constant that represents how many tiles away from the player we should be at all times. 
		//used basically by having removing the last x nodes from our A* path
		private static const MIN_DIS_TO_PLAYER:int = 3;
		
		//A constant used to tell when to start following the player. Basically the euclidean distance required before we start following the player. 
		private static const MAX_DIS_TO_PLAYER:Number = 50;
		
		//the speed we follow the player at
		private static const WALK_SPEED:Number = 70;
		
		//looks like I'll at least need a variable to tell if we're following the player
		private var _followingPlayer:Boolean = false;
		private var _player:Player;
		
		//Here's a variable to tell us if we're getting on the train. 
		private var _boardingTrain:Boolean = false;
		
		//And it looks like we'll need a reference to the floor map so we can perform proper A*
		private var _map:FlxTilemap;
		//And here is me getting fed up and cheating by basically just stealing the top of the map from everywhere else
		private var _topOfMap:Array = [
			[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1],
			[1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1],
			[1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1],
			[1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1],
		];
		
		
		
		//Same stuff the player has for entering the train since FBI agents can also enter the train
		private var _inTrainDoors:Boolean = false;
		private var _insideTrain:Boolean = false;
		
		//getters & setters
		public function get inTrainDoors():Boolean
		{
			return _inTrainDoors;
		}
		
		public function get insideTrain():Boolean
		{
			return _insideTrain;
		}
		public function set insideTrain(value:Boolean):void
		{
			_insideTrain = value;
		}
		
		
		
		
		public function FBIAgent(x:Number, y:Number, playerToFollow:Player, floorMap:FlxTilemap)
		{
			super(x, y, ResourceManager.agentArt);
			this.height = 10;
			this.offset.y = 2.5;
			
			_player = playerToFollow;
			_map = floorMap;
		}
		
		public override function update():void
		{
			super.update();
			
			//first, if the player just got on the train, we better get on as well
			if(!_boardingTrain && _player.inTrainDoors && !_player.insideTrain)
			{
				getInTrain();
			}
			//and if the sneaky bastard just got off the train, you need to too.
			else if(this._inTrainDoors && !_player.inTrainDoors)
			{
				getOffTrain();
			}
			else if(!_followingPlayer && !_player.inTrainDoors && !_boardingTrain && Math.sqrt(Math.pow(this.x-_player.x, 2)+Math.pow(this.y-_player.y, 2)) > MAX_DIS_TO_PLAYER)
				followPlayer();
			else if(_boardingTrain && !PlayState.Instance.trainDoorsOpen() )
			{
				this.stopFollowingPath(true);
			}
				
			
			//Since we should only be moving via paths, if our path becomes 0, we should really stop moving. 
			if(pathSpeed == 0)
			{
				this.velocity = new FlxPoint();
				_followingPlayer = false;
				_boardingTrain = false;
			}
			
			_inTrainDoors = false;
			
			//also, check to see if we're inside the train doors at all. If not, we also need to obey the same rules the player obeys.
			if(this.y < 70)
			{	
				//If the train has open doors, need to do some additional checks. 
				if(PlayState.Instance.trainDoorsOpen())
				{
					//Need to be within the proper x-range of one of the doors. 
					//Hmmm, somehow need access to the positions of the doors. 
					var doors:Array = PlayState.Instance.trainDoorList();
					var inRangeOfDoor:Boolean = false;
					for each(var door:FlxObject in doors)
					{
						if(this.x >= door.x && this.x + this.width <= door.x+door.width)
						{
							inRangeOfDoor = true;
							//Now check whether we're actually inside the door as well
							if(this.y+this.height <= door.y+door.height)
								_inTrainDoors = true;
							
						}
					}
					
					if(!inRangeOfDoor)
						this.y = 70;
				}
				else
					this.y = 70;
			}
			
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
		
		private function getInTrain():void
		{
			//first let's grab a list of the doors. 
			var doors:Array = PlayState.Instance.trainDoorList();
			//For now, let's just find the door with the closest euclidean distance (should be easier on our processor than doing A* and choosing the shortest path-length).
			var shortest_dis:Number = Number.MAX_VALUE;
			var closestDoor:FlxObject = null;
			for each(var door:FlxObject in doors)
			{
				//not even going to use the square root here since I'm just comparing distances.
				var dis:Number = Math.pow(this.x-door.x, 2) + Math.pow(this.y-door.y, 2);
				if(dis < shortest_dis)
				{
					shortest_dis = dis;
					closestDoor = door;
				}
			}
			
			//now that we have the closest door, we need to find a path to it. 
			var startPoint:FlxPoint = new FlxPoint(Math.floor(this.x/Globals.GRID_CELL_SIZE), Math.floor(this.y/Globals.GRID_CELL_SIZE));
			var destPoint:FlxPoint = new FlxPoint(Math.floor((closestDoor.x+closestDoor.width/2)/Globals.GRID_CELL_SIZE), Math.floor((closestDoor.y+closestDoor.height/2)/Globals.GRID_CELL_SIZE));
			var map:Array = createAStarMap();
			var columns:int = map.length;
			var rows:int = map[0].length;
			
			var path:Array = AStar.A_Star(startPoint, destPoint, map, columns, rows);
			
			//Now, go ahead and dash into that train!
			this.followPath(new FlxPath(path), 2*WALK_SPEED);
			_boardingTrain = true;
			
		}
		//Simple, just get the crap off that train
		private function getOffTrain():void
		{
			var offTrainPoint:FlxPoint = new FlxPoint(this.x, this.y+40);
			this.followPath(new FlxPath([offTrainPoint]), WALK_SPEED);
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
					if(j < 2)
						column.push(1);
					else if(j < Math.floor(_map.y/Globals.GRID_CELL_SIZE))
						column.push(_topOfMap[j-2][i]);
					else
						column.push(_map.getTile(i, j-Math.floor(_map.y/Globals.GRID_CELL_SIZE)));
				}
				
				simpleMap.push(column);
			}
			return simpleMap;
		}
	}
}
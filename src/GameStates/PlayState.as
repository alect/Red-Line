package GameStates
{
	import GameObjects.FBIAgent;
	import GameObjects.Player;
	import GameObjects.Train;
	
	import Utilities.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		
		//our global instance. Useful so that objects can access the general game state
		public static var Instance:PlayState;
		
		//the player character in this instance. 
		private var _player:Player;
		
		//the fbi agent to follow the player
		private var _agent:FBIAgent;
		
		//the train itself. 
		private var _train:Train;
		
		//the floor everyone hangs out on. 
		private var _floorMap:FlxTilemap;
		
		//A test string to test out the tilemap for now
		private var _simpleMap:String = 
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n";
		
		
		
		//The map used to represent the border of the world. Simple way of keeping the player off the screen.
		//Notice how it specifically has marks carved out for the train doors
		private var _borderMap:FlxTilemap;
		private var _borderMapString:String =
			"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\n" +
			"1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1\n" +
			"1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1\n" +
			"1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1\n" +
			"1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n" +
			"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\n";
		
		public override function create():void
		{
			
			//The border map doesn't even have to be visible, but we'll just put it at the bottom for now. 
			_borderMap = new FlxTilemap();
			_borderMap.loadMap(_borderMapString, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0, 1);
			_borderMap.x = -10;
			_borderMap.y = 20;
			this.add(_borderMap);
			
			//first place the background train tracks
			var trainTracks:FlxSprite = new FlxSprite(0, 0, ResourceManager.trainTrackArt);
			this.add(trainTracks);
			
			
			
			_floorMap = new FlxTilemap();
			_floorMap.loadMap(_simpleMap, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0, 1);
			_floorMap.y = 70;
			
			this.add(_floorMap);
			
			_train = new Train(3, 2);
			this.add(_train);
			
			
			_player = new Player(20, 120);
			this.add(_player);
			
			
			_agent = new FBIAgent(0, 100, _player, _floorMap);
			this.add(_agent);
			
			_floorMap.solid = true;
			
			Instance = this;
			
		}
		
		public override function update():void
		{
			FlxG.collide(_player, _floorMap);
			FlxG.collide(_player, _borderMap);
			FlxG.collide(_agent, _floorMap);
			
			super.update()
		}
		
		//Essential Game State functions
		public function trainDoorsOpen():Boolean
		{
			return _train.doorsOpen;
		}
		
		public function trainDoorList():Array
		{
			return _train.getTrainDoors();
		}
		
		//Function that's called when the train doors close. Can handle making the player disappear etc. 
		public function onTrainDoorsClosed():void
		{
			//If the player is inside the train doors, the player is now inside the train
			if(_player.inTrainDoors)
			{
				_player.insideTrain = true;
				_player.active = false;
				_player.visible = false;
			}
			//Same with the FBI Agent
			if(_agent.inTrainDoors && _agent.active)
			{
				_agent.insideTrain = true;
				_agent.active = false;
				_agent.visible = false;
			}
		}
		
		//Function that's called when the train leaves the station. Time to check victory and loss conditions
		public function onTrainLeaveStation():void
		{
			//Now check our victory and loss conditions
			if(_player.insideTrain)
			{
				if(_agent.insideTrain)
					trace("LOSE!!");
				else
					trace("WIN!!");
			}
			//let the FBI Agents dissapear if they get in the train without the player
			else if(_agent.insideTrain)
			{
				_agent.insideTrain = false;
			}
			
			
		}
		
		
		
	}
}
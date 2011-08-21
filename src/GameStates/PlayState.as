package GameStates
{
	import GameObjects.Commuter;
	import GameObjects.FBIAgent;
	import GameObjects.Player;
	import GameObjects.Train;
	import GameObjects.VerticalCommuter;
	
	import Utilities.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		
		//our global instance. Useful so that objects can access the general game state
		public static var Instance:PlayState;
		
		//the trainTracks to render
		private var _trainTracks:FlxSprite;
		
		
		//the player character in this instance. 
		private var _player:Player;
		
		//the fbi agents to follow the player
		private var _agents:FlxGroup;
		//and let's make this globally available so the agents can use it for their calculations
		public function get agents():FlxGroup
		{
			return _agents;
		}
		
		
		//the commuters to get in the way and/or help the player
		private var _commuters:FlxGroup;
		
		//the vertical commuters who get off the train when it arrives
		private var _verticalCommuters:FlxGroup;
		
		//the train itself. 
		private var _train:Train;
		
		//the floor everyone hangs out on. 
		private var _floorMap:FlxTilemap;
	
		
		//The map used to represent the border of the world. Simple way of keeping the player off the screen.
		//Notice how it specifically has marks carved out for the train doors
		private var _borderMap:FlxTilemap;
		private var _borderMapString:String =
			"2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\n" +
			"2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2\n" +
			"2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2\n" +
			"2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2\n" +
			"2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2\n" +
			"2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\n";
		
		//and our current level index
		private var _currentLevelIndex:int = 0;
		private var _currentLevel:Level;
		
		//Here is some text to indicate whether we've won or lost
		//along with some booleans to allow us to reset and shit
		private var _loseText:FlxText;
		private var _resetText:FlxText;
		private var _lost:Boolean = false;
		
		private var _winText:FlxText;
		private var _nextLevelText:FlxText;
		private var _won:Boolean = false;
		
		//sound effects for when we win or lose the level. 
		private static var _winSound:FlxSound = new FlxSound();
		_winSound.loadEmbedded(ResourceManager.winSound);
		private static var _loseSound:FlxSound = new FlxSound();
		_loseSound.loadEmbedded(ResourceManager.loseSound);
		
		public override function create():void
		{
			
			//Here let's make some basic UI stuff
			_loseText = new FlxText(0, 70, FlxG.width, "Capture! You didn't lose 'em!");
			_loseText.alignment = "center";
			_loseText.size = 16;
			_resetText = new FlxText(0, 90, FlxG.width, "Click to reset level");
			_resetText.alignment = "center";
			
			_winText = new FlxText(0, 70, FlxG.width, "Escape! You lost 'em!");
			_winText.alignment = "center";
			_winText.size = 16;
			_nextLevelText = new FlxText(0, 90, FlxG.width, "Click for next level");
			_nextLevelText.alignment = "center";
			
			
			
			//The border map doesn't even have to be visible, but we'll just put it at the bottom for now. 
			_borderMap = new FlxTilemap();
			_borderMap.loadMap(_borderMapString, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0, 1);
			_borderMap.x = -10;
			_borderMap.y = 20;
			
			
			//first place the background train tracks
			_trainTracks = new FlxSprite(0, 0, ResourceManager.trainTrackArt);
			
			//Let's test out loading our levels. 
			_currentLevel = LevelLoader.loadLevel(ResourceManager.levelList[_currentLevelIndex]);
			
			//and let's load from our level. 
			clearLevel();
			loadFromLevel(_currentLevel);
			
			Instance = this;
			
		}
		
		private function clearLevel():void
		{
			this.clear();
			_lost = false;
			_won = false;
			this.add(_borderMap);
			this.add(_trainTracks);
		}
		
		private function loadFromLevel(level:Level):void
		{
			_floorMap = new FlxTilemap();
			_floorMap.loadMap(level.gridCSV, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0, 2);
			_floorMap.y = 70;
			this.add(_floorMap);
			
			_train = new Train(3, 2);
			this.add(_train);
			
			_player = new Player(level.playerStartLocation.x, level.playerStartLocation.y+_floorMap.y, _floorMap);
			this.add(_player);
			
			_agents = new FlxGroup();
			for each(var agentLoc:FlxPoint in level.agentLocations)
			{
				var agent:FBIAgent = new FBIAgent(agentLoc.x, agentLoc.y+_floorMap.y, _player, _floorMap);
				_agents.add(agent);
			}
			this.add(_agents);
			
			_commuters = new FlxGroup();
			for each(var leftCommuterLoc:FlxPoint in level.leftCommuters)
			{
				var leftCommuter:Commuter = new Commuter(leftCommuterLoc.x, leftCommuterLoc.y+_floorMap.y, Commuter.COMMUTER_LEFT);
				_commuters.add(leftCommuter);
			}
			for each(var rightCommuterLoc:FlxPoint in level.rightCommuters)
			{
				var rightCommuter:Commuter = new Commuter(rightCommuterLoc.x, rightCommuterLoc.y+_floorMap.y, Commuter.COMMUTER_RIGHT);
				_commuters.add(rightCommuter);
			}
			this.add(_commuters);
			
			_verticalCommuters = new FlxGroup();
			for each(var verticalCommuterLoc:FlxPoint in level.verticalCommuters)
			{
				var verticalCommuter:VerticalCommuter = new VerticalCommuter(verticalCommuterLoc.x, verticalCommuterLoc.y);
				_verticalCommuters.add(verticalCommuter);
			}
			this.add(_verticalCommuters);
			
		}
		
		public override function update():void
		{
			FlxG.collide(_player, _commuters);
			FlxG.collide(_player, _verticalCommuters);
			FlxG.collide(_agents, _commuters);
			FlxG.collide(_agents, _verticalCommuters);
			FlxG.collide(_player, _floorMap);
			FlxG.collide(_player, _borderMap);
			FlxG.collide(_agents, _floorMap);
			FlxG.collide(_agents, _borderMap);
			
			//Here's where we handle having the agents collide
			//FlxG.collide(_agents, _agents);
			FlxG.overlap(_agents, _agents, function(agent1:FBIAgent, agent2:FBIAgent):void { agent1.hitOtherAgent();} );
			
			
			if(_lost && FlxG.mouse.justPressed())
			{
				clearLevel();
				loadFromLevel(_currentLevel);
			}
			if(_won && FlxG.mouse.justPressed())
			{
				if(_currentLevelIndex + 1 < ResourceManager.levelList.length)
				{
					_currentLevelIndex++;
					_currentLevel = LevelLoader.loadLevel(ResourceManager.levelList[_currentLevelIndex]);
					clearLevel();
					loadFromLevel(_currentLevel);
				}
				else
					FlxG.switchState(new EndingState());
			}
			
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
		
		//Function that's called when the train doors are opened. Causes the vertical commuters to spawn
		public function onTrainDoorsOpened():void
		{
			for each(var verticalCommuter:VerticalCommuter in _verticalCommuters.members)
				verticalCommuter.spawnInGame();
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
			for each(var agent:FBIAgent in _agents.members)
			{
				if(agent.inTrainDoors && agent.active)
				{
					agent.insideTrain = true;
					agent.active = false;
					agent.visible = false;
				}
			}
		}
		
		//Function that's called when the train leaves the station. Time to check victory and loss conditions
		public function onTrainLeaveStation():void
		{
			var agentInTrain:Boolean = false;
			for each(var agent:FBIAgent in _agents.members)
			{
				if(agent.insideTrain)
					agentInTrain = true;
			}
			//Now check our victory and loss conditions
			if(_player.insideTrain)
			{
				if(agentInTrain)
				{
					this.add(_loseText);
					this.add(_resetText);
					_lost = true;
					_loseSound.play();
				}
				else
				{
					this.add(_winText);
					this.add(_nextLevelText);
					_won = true;
					_winSound.play();
				}
			}
			//let the FBI Agents dissapear if they get in the train without the player
			else if(agentInTrain)
			{
				for each(var agentAgain:FBIAgent in _agents.members)
				{
					agentAgain.insideTrain = false;
				}
			}
			
			
		}
		
		
		
	}
}
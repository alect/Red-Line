package GameObjects
{
	import GameStates.PlayState;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import Utilities.ResourceManager;
	
	public class Player extends FlxSprite
	{
		
		private static const PLAYER_WALK_SPEED:Number = 80;
		
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
		
		
		public function Player(x:Number, y:Number)
		{
			super(x, y, ResourceManager.playerArt);
			//this.makeGraphic(10, 10, 0xff0000ff);
			this.width = 10;
			this.height=10;
			this.offset.y = 2.5;
			
			//set up our drag for natural movement
			drag.x = PLAYER_WALK_SPEED * 8;
			drag.y = PLAYER_WALK_SPEED * 8;
			this.maxVelocity = new FlxPoint(PLAYER_WALK_SPEED, PLAYER_WALK_SPEED);
		
		}
		
		public override function update():void
		{
			//let's get some controls up in here. 
			this.acceleration = new FlxPoint(0, 0);
			if(FlxG.keys.DOWN || FlxG.keys.UP || FlxG.keys.LEFT || FlxG.keys.RIGHT)
			{
				if(FlxG.keys.DOWN)
				{
					this.acceleration.y = drag.y;	
				}
				
				if(FlxG.keys.UP)
				{
					this.acceleration.y = -drag.y;
				}
				
				if(FlxG.keys.LEFT)
				{
					this.acceleration.x = -drag.x;
				}
				
				if(FlxG.keys.RIGHT)
				{
					this.acceleration.x = drag.x;
				}
				
				//update our max-velocity to take diagonal movement into account
				if( (FlxG.keys.UP && FlxG.keys.LEFT) || (FlxG.keys.UP && FlxG.keys.RIGHT) || (FlxG.keys.DOWN && FlxG.keys.LEFT) || (FlxG.keys.DOWN && FlxG.keys.RIGHT))
					this.maxVelocity = new FlxPoint(PLAYER_WALK_SPEED*Math.SQRT1_2, PLAYER_WALK_SPEED*Math.SQRT1_2);
				else
					this.maxVelocity = new FlxPoint(PLAYER_WALK_SPEED, PLAYER_WALK_SPEED);
			}
			
			
			
			super.update();
			if(this.x < 0)
				this.x = 0;
			if(this.x+this.width > FlxG.width)
				this.x = FlxG.width-this.width;
			
			//reset our inTrain state so we can update if we need to 
			_inTrainDoors = false;
			
			//got to keep the player off the tracks unless there's a train there.
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
	}
}
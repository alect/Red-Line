package GameObjects
{
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import GameStates.PlayState;
	import Utilities.ResourceManager;
	
	public class Train extends FlxSprite
	{
		
		private static const TRAIN_SPEED:Number = 200;
		
		private var _timeTillEnterStation:Number;
		private var _timeDoorsOpen:Number;
		
		private static const TIME_TO_OPEN_DOORS:Number = .5;
		
		//used to keep track of how much time has passed. 
		private var _timeCounter:Number;
		
		private static const WAITING_TO_ENTER:uint = 0;
		private static const ENTERING:uint = 1;
		private static const OPENING_DOORS:uint = 2;
		private static const WAITING_FOR_DOORS:uint = 3;
		private static const CLOSING_DOORS:uint = 4;
		private static const LEAVING:uint = 5;
		
		private var _state:uint;
		
		//the door images. 
		private var _leftDoor:FlxSprite;
		private var _middleDoor:FlxSprite;
		private var _rightDoor:FlxSprite;
		
		private var _doorsOpen:Boolean = false;
		//The doors open gets a getter
		public function get doorsOpen():Boolean
		{
			return _doorsOpen;
		}
		
		
		public function Train(timeEnterStation:Number, timeDoorsOpen:Number)
		{
			_timeTillEnterStation = timeEnterStation;
			_timeDoorsOpen = timeDoorsOpen;
			
			//The train always starts off to the right of the screen.
			super(FlxG.width, 0, ResourceManager.trainArt);
			//this.makeGraphic(FlxG.width, 60, 0xff808080);
			
			//our default starting state is waiting to enter. 
			_state = WAITING_TO_ENTER;
			_timeCounter = 0;
			
			_leftDoor = new FlxSprite(0, 0, ResourceManager.trainDoorArt);
			//_leftDoor.makeGraphic(20, 30, 0xffffff00);
			
			_middleDoor = new FlxSprite(0, 0, ResourceManager.trainDoorArt);
			//_middleDoor.makeGraphic(20, 30, 0xffffff00);
			
			_rightDoor = new FlxSprite(0, 0, ResourceManager.trainDoorArt);
			//_rightDoor.makeGraphic(20, 30, 0xffffff00);
			
			
			_doorsOpen = false;
		}
		
		public override function update():void
		{
			_timeCounter+=FlxG.elapsed;
			
			
			//Here's where we go ahead and do our statemachine swap
			switch(_state)
			{
				case WAITING_TO_ENTER:
					if(_timeCounter >= _timeTillEnterStation)
					{
						//create a path to follow. 
						var pathPoint:FlxPoint = new FlxPoint(FlxG.width/2, this.height/2);
						var simplePath:FlxPath = new FlxPath([pathPoint]);
						this.followPath(simplePath, TRAIN_SPEED);
						_state = ENTERING;
					}
					break;
				case ENTERING:
					//if we've reached our destination, time to wait for the doors. 
					if(this.pathSpeed == 0)
					{
						_timeCounter = 0;
						velocity = new FlxPoint(0, 0);
						_state = OPENING_DOORS;
					}
					break;
				case OPENING_DOORS:
					if(_timeCounter >= TIME_TO_OPEN_DOORS)
					{
						_timeCounter = 0;
						_state = WAITING_FOR_DOORS;
						_doorsOpen = true;
					}
					break;
				case WAITING_FOR_DOORS:
					if(_timeCounter >= _timeDoorsOpen)
					{
						_timeCounter = 0;
						_doorsOpen = false;
						_state = CLOSING_DOORS;
						//Call the main event function
						PlayState.Instance.onTrainDoorsClosed();
					}
					break;
				case CLOSING_DOORS:
					if(_timeCounter >= TIME_TO_OPEN_DOORS)
					{
						var exitPoint:FlxPoint = new FlxPoint(-FlxG.width/2, this.height/2);
						this.followPath(new FlxPath([exitPoint]), TRAIN_SPEED);
						_state = LEAVING;
					}
					break;
				case LEAVING:
					if(this.pathSpeed == 0)
					{
						_timeCounter = 0;
						velocity = new FlxPoint(0, 0);
						this.x = FlxG.width;
						_state = WAITING_TO_ENTER;
						//If we've officially left the station, time to check victory conditions.
						PlayState.Instance.onTrainLeaveStation();
						
					}
					break;
					
			}
			
			super.update();
		}
		
		public override function draw():void
		{
			//first draw ourselves. 
			super.draw();
			
			//next, position our doors and draw them. 
			_leftDoor.x = this.x+40;
			_leftDoor.y = this.y+this.height-_leftDoor.height;
			
			_middleDoor.x = this.x+this.width/2-_leftDoor.width/2;
			_middleDoor.y = this.y+this.height-_middleDoor.height;
			
			_rightDoor.x = this.x+this.width-40-_rightDoor.width;
			_rightDoor.y = this.y+this.height-_rightDoor.height;
			
			
			if(!_doorsOpen)
			{
				_leftDoor.draw();
				_middleDoor.draw();
				_rightDoor.draw();
			}
			
		}
		
		
		//A function to access the positions of the train doors (should be kept up to date by the draw function)
		public function getTrainDoors():Array
		{
			return [_leftDoor, _middleDoor, _rightDoor];
		}
		
		
	}
}
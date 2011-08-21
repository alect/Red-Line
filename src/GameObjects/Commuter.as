package GameObjects
{
	import Utilities.ResourceManager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Commuter extends FlxSprite
	{
		//some constants to denote the direction we're moving in. 
		public static const COMMUTER_RIGHT:uint = 0;
		public static const COMMUTER_LEFT:uint = 1;
		
		//the amount of time before we reappear on the other side of the screen
		private var _timeToRespawn:Number;
		private var _timerCounter:Number = 0;
		private var _direction:uint;
	
		private static const COMMUTER_SPEED:Number = 130;
		
		public function Commuter(x:Number, y:Number, direction:uint, respawnTime:Number=3.0)
		{
			super(x, y, ResourceManager.commuterArt);
			this.height = 10;
			this.offset.y = 2.5;
			
			_timeToRespawn = respawnTime;
			_direction = direction;
			if(_direction == COMMUTER_LEFT)
				this.facing = LEFT;
			this.immovable = true;
		}
		
		public override function update():void
		{
			this.velocity = new FlxPoint();
			
			//first, if we're on screen, then we need to MOVE
			if(x+width > 0 && _direction == COMMUTER_LEFT)
			{
				velocity.x = -COMMUTER_SPEED;
			}
			else if(x < FlxG.width && _direction == COMMUTER_RIGHT)
			{
				velocity.x = COMMUTER_SPEED;
			}
			//otherwise, we need to wait until we can spawn again.
			else
			{
				_timerCounter+=FlxG.elapsed;
				if(_timerCounter >= _timeToRespawn)
				{
					_timerCounter = 0;
					//if we're to the right of the screen, spawn to the left
					if(x >= FlxG.width)
					{
						x = -width;
					}
					//and if we're to the left, spawn to the right
					else
					{
						x = FlxG.width;
					}
				}
			}
			super.update();
		}
	}
}
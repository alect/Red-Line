package GameObjects
{
	import Utilities.Globals;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * Vertical commuters are like normal commuters except they only appear when the train opens its doors and they move down
	 */
	public class VerticalCommuter extends Commuter
	{
		//Vertical commuters all spawn at the doors of the train. The X coordinate tells us which door. 
		//and the y coordinate tells us how long to wait before spawning. 
		private var _spawnX:Number;
		private var _waitTime:Number;
		
		private var _spawning:Boolean = false;
		private var _spawned:Boolean = false;
		
		public function VerticalCommuter(x:Number, y:Number)
		{
			super(-10, -10, COMMUTER_DOWN);
			_spawnX = x;
			_waitTime = y/COMMUTER_SPEED;
		}
		
		public override function update():void
		{
			this.velocity = new FlxPoint();
			if(_spawning && !_spawned)
			{
				_timerCounter+=FlxG.elapsed;
				if(_timerCounter >= _waitTime)
				{
					this.x = _spawnX;
					this.y = 60;
					_spawned = true;
					_spawning = false;
				}
			}
			else if(_spawned)
			{
				velocity.y = COMMUTER_SPEED;
				if(y > FlxG.height)
				{
					_spawned = false;
				}
			}
			super.update();
		}
		
		public function spawnInGame():void
		{
			_spawning = true;
			_timerCounter = 0
		}
	}
}
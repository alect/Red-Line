package GameObjects
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	
	public class Player extends FlxSprite
	{
		
		private static const PLAYER_WALK_SPEED:Number = 80;
		
		
		public function Player(x:Number, y:Number)
		{
			super(x, y);
			this.makeGraphic(10, 10, 0xff0000ff);
			
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
			}
			
			super.update();
			if(this.x < 0)
				this.x = 0;
			if(this.x+this.width > FlxG.width)
				this.x = FlxG.width-this.width;
			
			//got to keep the player off the tracks unless there's a train there. 
			if(this.y < 70)
				this.y = 70;
		}
	}
}
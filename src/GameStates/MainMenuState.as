package GameStates
{
	import GameObjects.Player;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MainMenuState extends FlxState
	{
		public override function create():void
		{
			var helloWorld:FlxText = new FlxText(0, 0, FlxG.width, "Red-Line to Shady Grove");
			helloWorld.size = 16;
			helloWorld.alignment = "center";
			this.add(helloWorld);
		}
		
		public override function update():void
		{
			//Jump to the play-state if it's time
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
			super.update();
		}
	}
}
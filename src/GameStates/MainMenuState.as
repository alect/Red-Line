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
			var helloWorld:FlxText = new FlxText(0, 0, FlxG.width, "Hello, world!");
			helloWorld.alignment = "center";
			this.add(helloWorld);
			
			this.add(new Player(22, 22));
		}
	}
}
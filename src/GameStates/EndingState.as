package GameStates
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	import Utilities.ResourceManager
	
	public class EndingState extends FlxState
	{
		private var _simpleTitleTiles:String = 
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n"+
			"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n";
		
		public override function create():void
		{
			var title:FlxText = new FlxText(0, 0, FlxG.width, "That's all for now");
			title.size = 16;
			title.alignment = "center";
			
			var credits:FlxText = new FlxText(0, title.y+20, FlxG.width, "Thanks for playing!");
			credits.alignment = "center";
			
			var simpleTiles:FlxTilemap = new FlxTilemap();
			simpleTiles.loadMap(_simpleTitleTiles, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0);
			simpleTiles.y = 70;
			this.add(simpleTiles);
			
			
			this.add(title);
			
			
			this.add(credits);
			
			var tracks:FlxSprite = new FlxSprite(0, credits.y+20, ResourceManager.trainTrackArt);
			this.add(tracks);
			
			
			
			var click:FlxText = new FlxText(0, FlxG.height/2, FlxG.width, "Click to go to title");
			click.alignment = "center";
			this.add(click);
			
			
			var FBI1:FlxSprite = new FlxSprite(FlxG.width/2-20, click.y+40, ResourceManager.agentArt);
			this.add(FBI1);
			
			var FBI2:FlxSprite = new FlxSprite(FlxG.width/2+20, click.y+40, ResourceManager.agentArt);
			this.add(FBI2);
			
		}
		
		public override function update():void
		{
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new MainMenuState());
			super.update();
		}
	}
}
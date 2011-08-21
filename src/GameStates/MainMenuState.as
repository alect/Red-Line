package GameStates
{
	import GameObjects.Player;
	
	import Utilities.ResourceManager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	public class MainMenuState extends FlxState
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
			var title:FlxText = new FlxText(0, 0, FlxG.width, "Red-Line to Shady Grove");
			title.size = 16;
			title.alignment = "center";
			
			var credits:FlxText = new FlxText(0, title.y+20, FlxG.width, "A game by Alec Thomson");
			credits.alignment = "center";
			
			var simpleTiles:FlxTilemap = new FlxTilemap();
			simpleTiles.loadMap(_simpleTitleTiles, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0);
			simpleTiles.y = 70;
			this.add(simpleTiles);
			
			
			this.add(title);
			
			
			this.add(credits);
			
			var tracks:FlxSprite = new FlxSprite(0, credits.y+20, ResourceManager.trainTrackArt);
			this.add(tracks);
			
			var train:FlxSprite = new FlxSprite(0, credits.y+20, ResourceManager.trainArt);
			this.add(train);
			
			
			var click:FlxText = new FlxText(0, FlxG.height/2, FlxG.width, "Click to begin!");
			click.alignment = "center";
			this.add(click);
			
			var player:FlxSprite = new FlxSprite(FlxG.width/2, click.y+40, ResourceManager.playerArt);
			this.add(player);
			
			var FBI1:FlxSprite = new FlxSprite(player.x-20, player.y, ResourceManager.agentArt);
			this.add(FBI1);
			
			var FBI2:FlxSprite = new FlxSprite(player.x+20, player.y, ResourceManager.agentArt);
			this.add(FBI2);
			
			var shamelessPlug:FlxText = new FlxText(0, 200, FlxG.width, "Check out my other games at: www.alecthomson.com");
			shamelessPlug.alignment = "center";
			this.add(shamelessPlug);
		}
		
		public override function update():void
		{
			//Jump to the play-state if it's time
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new TutorialState());
			super.update();
		}
	}
}
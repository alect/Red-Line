package GameStates
{
	import Utilities.ResourceManager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	
	
	public class TutorialState extends FlxState
	{
		private var _puddleString:String = 
			"0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,1,1,0,0,0,0,0,0,0,0\n" +
			"0,1,1,1,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0\n";
		
		private var _simpleString:String = 
			"0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0\n" +
			"0,0,0,0,0,0,0,0,0,0,0,0\n";
		
		public override function create():void
		{
			var howToPlay:FlxText = new FlxText(0, 0, FlxG.width, "How to Play");
			howToPlay.alignment = "center";
			howToPlay.size = 16;
			this.add(howToPlay);
			
			var story:FlxText = new FlxText(0, howToPlay.y+20, FlxG.width, "You are a shady character of some sort about to undergo some unsavory business. Problem is, you've got a few pesky FBI Agents conspicuously following your every move. You need to lose those chumps by somehow getting on the train without them.");
			//story.alignment = "center";
			this.add(story);
			
			var simpleMap:FlxTilemap = new FlxTilemap();
			simpleMap.loadMap(_simpleString, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0, 2);
			simpleMap.x = FlxG.width/2-simpleMap.width/2;
			simpleMap.y = story.y+story.height-10;
			this.add(simpleMap);
			
			var you:FlxSprite = new FlxSprite(FlxG.width/2-40, story.y+story.height, ResourceManager.playerArt);
			this.add(you);
			
			var fbi:FlxSprite = new FlxSprite(FlxG.width/2+20, story.y+story.height, ResourceManager.agentArt);
			this.add(fbi);
			
			var youText:FlxText = new FlxText(you.x-6, you.y+15, FlxG.width, "You");
			this.add(youText);
			
			var fbiText:FlxText = new FlxText(fbi.x-20, fbi.y+15, FlxG.width, "FBI Agent");
			this.add(fbiText);
			
			var moreLessons:FlxText = new FlxText(0, fbiText.y+fbiText.height+10, FlxG.width, "The only controls are using the arrow keys to move, but you have various methods at your disposal. puddles will slow down both you and the agent, and busy commuters will push you around. Of course, there's no substitute for old-fashioned good timing. Good Luck!");
			this.add(moreLessons);
			
			var puddleMap:FlxTilemap = new FlxTilemap();
			puddleMap.loadMap(_puddleString, ResourceManager.floorMapArt, 10, 10, FlxTilemap.OFF, 0, 0, 2);
			puddleMap.x = FlxG.width/2-puddleMap.width/2;
			puddleMap.y = moreLessons.y+moreLessons.height+10;
			this.add(puddleMap);
			
			var puddleText:FlxText = new FlxText(puddleMap.x+3, puddleMap.y+puddleMap.height-20, FlxG.width, "Puddles");
			this.add(puddleText);
			
			var commuter:FlxSprite = new FlxSprite(FlxG.width/2+20, puddleMap.y+15, ResourceManager.commuterArt);
			this.add(commuter);
			
			var commuterText:FlxText = new FlxText(commuter.x-20, commuter.y+15, FlxG.width, "Commuter");
			this.add(commuterText);
		}
		
		public override function update():void
		{
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
			super.update();
		}
	}
}
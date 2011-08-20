package GameStates
{
	import GameObjects.FBIAgent;
	import GameObjects.Player;
	
	import Utilities.*;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState
	{
		//the player character in this instance. 
		private var _player:Player;
		
		//the fbi agent to follow the player
		private var _agent:FBIAgent;
		
		public override function create():void
		{
			_player = new Player(20, 20);
			this.add(_player);
			
			
			_agent = new FBIAgent(0, 0, _player);
			this.add(_agent);
			
			
		}
	}
}
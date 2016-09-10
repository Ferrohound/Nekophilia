package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	//two player objects, one controlled by WASD one by the arrow keys
	//look into Haxe inheritance 
	var _player1:Player1;
	var _player2:Player2;
	
	private var _level:FlxTilemap;
	
	override public function create():Void
	{
		//make the mouse invisible
		FlxG.mouse.visible = false;
		
		//add the two players to the game
		_player1 = new Player1(10,10);
		add(_player1);
		_player2 = new Player2(20, 10);
		add(_player2);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

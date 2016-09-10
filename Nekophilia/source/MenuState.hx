package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	var _playButton:FlxButton;
	override public function create():Void
	{
		//creating a button?
		add(new FlxText(10, 10, 200, "Testing, testing, 1,2,3"));
		_playButton = new FlxButton(100, 100, "LET'S GO", clickPlay);
		_playButton.screenCenter();
		add(_playButton);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function clickPlay(): Void
	{
		//switch to playstate
		FlxG.switchState(new PlayState());
	}
	
}

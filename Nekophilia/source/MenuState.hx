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
		var bg = new FlxSprite();
		bg.loadGraphic("assets/images/Main_Menu.png");
		add(bg);
		_playButton = new FlxButton(FlxG.width, 400, "PLAY", clickPlay);
		add(_playButton);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([ENTER, SPACE])) {
			clickPlay();
		}
	}
	
	function clickPlay(): Void
	{
		//switch to playstate
		FlxG.switchState(new PlayState());
	}
	
}

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
		var wider = FlxG.width / 3.0 > FlxG.height / 2.0;
		bg.setGraphicSize(wider ? 0 : FlxG.width, wider ? FlxG.height : 0);
		bg.screenCenter();
		add(bg);
		_playButton = new FlxButton(FlxG.width / 2, 7 * FlxG.height / 8, "PLAY", clickPlay);
		_playButton.x -= _playButton.width / 2;
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

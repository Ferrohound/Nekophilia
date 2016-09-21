package;

import flixel.FlxGame;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.FlxG;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		addChild(new FlxGame(0, 0, MenuState, 2, 60, 60, true));
		FlxG.scaleMode = new RatioScaleMode();
	}
}

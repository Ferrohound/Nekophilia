package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

//door game object
class Door extends FlxSprite
{
	public var _open:Bool;
	public function new(X:Float=0, Y:Float=0, open:Bool = false) 
	{
		super(X, Y);
		_open = open;
	}
}
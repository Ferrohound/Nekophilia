package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

//door game object
class Door extends FlxSprite
{
	public var _open:Bool;
	public var _x:Float;
	public var _y:Float;
	public function new(X:Float=0, Y:Float=0, open:Bool = false, id:Int=27) 
	{
		super(X, Y);
		_x = X;
		_y = Y;
		if (id == 27)
			loadGraphic("assets/images/door.png", true, 64, 64);
		if (id == 28)
			loadGraphic("assets/images/door2.png", true, 64, 64);
		_open = open;
		drag.x = drag.y = 11000000;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		x = _x;
		y = _y;
	}
}
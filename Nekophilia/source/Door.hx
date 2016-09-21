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
	public var _graphic:String;
	public function new(X:Float=0, Y:Float=0, open:Bool = false, id:Int=27) 
	{
		super(X, Y);
		_x = X;
		_y = Y;
		if (id == 27){
			if(!open)
				loadGraphic("assets/images/door.png", false, 64, 64);
			else
				loadGraphic("assets/images/alpha.png", false, 64, 64);
			_graphic = "assets/images/door.png";
		}
		else if (id == 28){
			if(!open)
				loadGraphic("assets/images/door2.png", false, 64, 64);
			else
				loadGraphic("assets/images/alpha.png", false, 64, 64);
			_graphic = "assets/images/door2.png";
		}
		else{
			if (!open)
				loadGraphic("assets/images/door3.png", false, 64, 64);
			else
				loadGraphic("assets/images/alpha.png", false, 64, 64);
			_graphic = "assets/images/door3.png";
		}
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
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;	

class Box extends FlxSprite
{

	//play smoke animation while dragged
	public function new(?X:Float = 0, ?Y:Float = 0, ?big:Bool){
		super(X, Y);
		if (big == true) { // Looks stupid, but could be null
			loadGraphic("assets/images/bigBox.png", false, 128, 128);
		} else {
			loadGraphic("assets/images/Box.png", false, 64, 64);
		}
		acceleration.y = 600;
	}
}
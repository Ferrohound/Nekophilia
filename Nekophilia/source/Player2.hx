package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;	

class Player2 extends Player
{

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		deathScript = Assets.getText("assets/text/deaths/aimee-death.txt");
		deathScriptTag = "aimee-death";
		
		setControls(W, S, A, D);

		speed = 300;
		jumpSpeed = 300;

		loadGraphic("assets/images/duck.png", true, 100, 114);
		animation.add("walk", [0, 1, 0, 2], 5, true);
	}
}
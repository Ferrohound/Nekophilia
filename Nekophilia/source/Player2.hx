package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import openfl.Assets;

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
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(FlxG.keys.anyJustPressed([E])){
			FlxG.overlap(PlayState._locks, this, function(lock:Lock, player:FlxObject)
			{
				lock.unlock();
			});
		}
	}
}
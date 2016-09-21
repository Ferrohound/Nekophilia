package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import openfl.Assets;

class Player1 extends Player
{
	public var lanternLit = true;
	
	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		deathScript = Assets.getText("assets/text/deaths/owen-death.txt");
		deathScriptTag = "owen-death";
		
		setControls(UP, DOWN, LEFT, RIGHT);
		
		var speed    :Float = 200;
		var jumpSpeed:Float = 500;
		
		loadGraphic("assets/images/Owen.png", true, 64, 96);
		animation.add("stand", [0, 1,  2,  3], 5, true);
		animation.add("walk",  [4, 5,  6,  7], 5, true);
		animation.add("wave",  [8, 9, 10, 11], 5, true);
		
		leftFootstep  = SoundStore._OleftFoot;
		rightFootstep = SoundStore._OrightFoot;
	}
	
	override public function update(elapsed:Float): Void
	{
		super.update(elapsed);
		
		if (lanternLit) {
			PlayState._shadows.addLightPoint(this.getMidpoint());
		}
		
		if (acceptInput && FlxG.keys.anyJustPressed([CONTROL])){
			FlxG.overlap(PlayState._candles, this, function(candle:Candle, Player:FlxObject)
			{
				candle.set_lit(true);
			});
		}
	}
	
}
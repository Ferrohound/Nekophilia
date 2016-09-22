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

	public var isCrouched(default, null) = false;
	
	public static inline var DARK_DEATH_TIME:Float = 5;
	var darkTimer:Float = 0;
	
	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		deathScript = Assets.getText("assets/text/deaths/aimee-death.txt");
		deathScriptTag = "aimee-death";
		
		setControls(W, S, A, D);

		speed = 300;
		jumpSpeed = 300;

		loadGraphic("assets/images/Aimee.png", true, 64, 96);
		animation.add("stand", [ 0,  1,  2,  3], 5, true);
		animation.add("walk",  [ 4,  5,  6,  7], 5, true);
		animation.add("pick",  [ 8,  9, 10, 11], 5, false);
		animation.add("crawl", [12, 13, 14, 15], 5, true);
		animation.add("crouch", [12, 14], 1, true);
		
		leftFootstep  = SoundStore._AleftFoot;
		rightFootstep = SoundStore._ArightFoot;
	}
	
	override public function update(elapsed:Float)
	{	
		if (acceptInput) {
			if (FlxG.keys.anyPressed([SHIFT])){
				if (!isCrouched) {
					isCrouched = true;
					height = frameHeight / 2;
					offset.y = frameHeight / 2;
					y += frameHeight / 2;
					standAnim = "crouch";
					walkAnim  = "crawl";
				}
			} else if (isCrouched) {
				isCrouched = false;
				height = frameHeight;
				offset.y = 0;
				y -= frameHeight / 2;
				standAnim = "stand";
				walkAnim  = "walk";
			}
		}
		
		super.update(elapsed);
		
		if (!PlayState._shadows.hasLightPoint(getMidpoint())) {
			FlxG.overlap(PlayState._deer, this, function(object:FlxObject, player:FlxObject){
				kill();
			});
			if (acceptInput) darkTimer += elapsed;
			if (alive) FlxG.camera.shake(0.05 * darkTimer / DARK_DEATH_TIME, 0.1);
			if (darkTimer >= DARK_DEATH_TIME) {
				kill();
			}
			}
			else {
			darkTimer = 0;
		}
		
		if (acceptInput && FlxG.keys.anyJustPressed([E])){
			FlxG.overlap(PlayState._locks, this, function(lock:Lock, player:FlxObject)
			{
				animation.play("pick");
				lock.unlock();
			});
		}
	}
}
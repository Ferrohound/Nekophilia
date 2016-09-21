package;

import flixel.FlxSprite;
import flixel.FlxObject;

class SmokeParticle extends FlxSprite
{
	public static inline var SPRITE_SIZE = 64;
	
	public function new(?X:Float = 0, ?Y:Float = 0){
		super(X, Y);
		origin.y = SPRITE_SIZE;
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT,   true, false);
		
		loadGraphic("assets/images/smoke.png", true, SPRITE_SIZE, SPRITE_SIZE);
		animation.add("poof", [0, 1, 2, 3, 4, 5, 6, 7, 8], 10, false);
		animation.add("s-poof", [0, 4, 5, 6, 7, 8], 10, false);
		animation.finishCallback = function(name:String)
		{
			this.kill();
		}
	}
	
	public static function spawn(?X:Float = 0, ?Y:Float = 0, movingRight:Bool = true, frameRate:Int = 10, small:Bool = false)
	{
		var inst = PlayState._smoke.getFirstAvailable(SmokeParticle);
		if (inst == null) {
			inst = PlayState._smoke.add(new SmokeParticle(X, Y));
		}
		inst.x = X;
		inst.y = Y;
		if (small) {
			inst.animation.play("s-poof");
		} else {
			inst.animation.play("poof");
		}
		inst.animation.curAnim.frameRate = frameRate;
		if (movingRight) {
			inst.facing = FlxObject.RIGHT;
		} else {
			inst.facing = FlxObject.LEFT;
		}
		inst.revive();
	}
}

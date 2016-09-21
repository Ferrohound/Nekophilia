package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

class Box extends FlxSprite
{
	public static inline var SMOKE_INTERVAL:Float = 32;
	
	private var smokeDist:Float = Math.POSITIVE_INFINITY;
	private var lastX:Float;
	
	public function new(?X:Float = 0, ?Y:Float = 0, big:Bool = false){
		super(X, Y);
		if (big) {
			loadGraphic("assets/images/bigBox.png", false, 128, 128);
		} else {
			loadGraphic("assets/images/Box.png", false, 64, 64);
		}
		acceleration.y = 600;
		drag.x = drag.y = 1100;
		lastX = X;
	}
	
	override public function update(elapsed:Float)
	{	
		var pushedDist = x - lastX;
		
		if (pushedDist != 0 && isTouching(FlxObject.FLOOR)) {
			smokeDist += Math.abs(pushedDist);
			
			if (smokeDist >= SMOKE_INTERVAL) {
				smokeDist = 0;
				SmokeParticle.spawn(x, y, pushedDist > 0);
			}
			SoundStore._boxDrag.volume = 1;
			SoundStore._boxDrag.play();
		} else {
			smokeDist = Math.POSITIVE_INFINITY;
			SoundStore._boxDrag.fadeOut(0.1);
		}
		
		lastX = x;
		super.update(elapsed);
	}
}

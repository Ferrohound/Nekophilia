package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;	

class Player1 extends Player
{
	private var shadows : ShadowSystem;
	
	public function new(?X:Float=0, ?Y:Float=0, shadows:ShadowSystem)
	{
		super(X, Y);
		setControls(W, S, A, D);
		
		var speed    :Float = 200;
		var jumpSpeed:Float = 500;
		
		this.shadows = shadows;
		
		loadGraphic("assets/images/duck.png", true, 100, 114);
		animation.add("walk", [0, 1, 0, 2], 5, true);
	}
	
	override public function update(elapsed:Float): Void
	{
		super.update(elapsed);
		
		shadows.addLightPoint(this.getMidpoint());
	}
}
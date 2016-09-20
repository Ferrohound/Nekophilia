package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;

class ShadowSystem extends FlxSprite
{
	public static inline var DEF_SHADOW_COLOR = 0xFF101020;
	public var shadowColor : FlxColor;

	public function new(shadowColor:FlxColor=DEF_SHADOW_COLOR)
	{
		super(0, 0);
		this.shadowColor = shadowColor;
		this.scrollFactor.set(0, 0);
		
		blend = BlendMode.MULTIPLY;
		makeGraphic(FlxG.width + 100, FlxG.height + 100, shadowColor);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function beginLights(p:FlxPoint) : Void
	{
		//x = FlxG.camera.scroll.x;
		//y = FlxG.camera.scroll.y;
		FlxSpriteUtil.fill(this, shadowColor);
	}
	
	public function addLightPoint(p:FlxPoint, radius=200.0, color=FlxColor.WHITE) : Void
	{
		addLight(p.x, p.y, radius, color);
	}
	
	public function addLight(px:Float, py:Float, radius=200.0, color=FlxColor.WHITE) : Void
	{
		//draws those coordonates relative to itself and not the game world
		FlxSpriteUtil.drawCircle(this, px - FlxG.camera.scroll.x, py - FlxG.camera.scroll.y, radius, color);
	}
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;

class ShadowSystem extends FlxSprite
{
	
	public var shadowColor : FlxColor;
	private var lights : Array<FlxPoint>;

	public function new(geometry:Array<FlxPoint>, shadowColor:FlxColor=0xFF101020) 
	{
		super(0, 0);
		this.shadowColor = shadowColor;
		
		blend = BlendMode.MULTIPLY;
		makeGraphic(FlxG.width, FlxG.height, shadowColor);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function beginLights() : Void
	{
		x = FlxG.camera.scroll.x;
		y = FlxG.camera.scroll.y;
		FlxSpriteUtil.fill(this, shadowColor);
	}
	
	public function addLightPoint(p:FlxPoint, radius=200.0, color=FlxColor.WHITE) : Void
	{
		addLight(p.x, p.y, radius, color);
	}
	
	public function addLight(x:Float, y:Float, radius=200.0, color=FlxColor.WHITE) : Void
	{
		FlxSpriteUtil.drawCircle(this, x, y, radius, color);
	}
}
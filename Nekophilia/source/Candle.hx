 package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;	

class Candle extends FlxSprite
{
	public var lit(default,set):Bool = false;
	public var _shadows:ShadowSystem;
	
	public function new(shadows:ShadowSystem,?X:Float = 0, ?Y:Float = 0){
		super(X, Y);
		_shadows = shadows;
		loadGraphic("assets/images/Candle.png", true, 64, 64);
		animation.add("flame", [1, 2, 3], 12, true);
	}
	
	override public function update(elapsed:Float): Void
	{
		super.update(elapsed);
		if(lit)
			_shadows.addLightPoint(getMidpoint());
	}
	
	public function set_lit(lit:Bool):Bool
	{
		this.lit = lit;
		if (lit) {
			animation.play("flame");
		} else {
			animation.reset();
		}
		return lit;
	}
}
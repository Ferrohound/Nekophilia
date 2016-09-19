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
	 //should have an array of doors it controls
	 //flips their _open state
	 public var _doors:FlxGroup;
	 public var _timer:Float = 10;
	 public var _lit:Bool;
	 public var _shadows:ShadowSystem;
	 
	 public function new(shadows:ShadowSystem,?X:Float = 0, ?Y:Float = 0){
		 super(X, Y);
		 _shadows = shadows;
		 _lit = false;
		 loadGraphic("assets/images/lock.png", true, 64, 64);
		 animation.add("open", [0, 1, 2, 3, 4, 5, 6], 6, false);
		 //animation.play("open");
	 }
	 override public function update(elapsed:Float): Void
	 {
		 super.update(elapsed);
		 if(_lit)
			_shadows.addLightPoint(this.getMidpoint());
	 }
	 
 }
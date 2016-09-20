 package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;	
 
 class Lock extends FlxSprite
 {
	 //should have an array of doors it controls
	 //flips their _open state
	 public var _doors:FlxGroup;
	 
	 public function new(state:PlayState,?X:Float = 0, ?Y:Float = 0){
		 super(X, Y);
		 loadGraphic("assets/images/lock.png", true, 64, 64);
		 animation.add("open", [0, 1, 2, 3, 4, 5, 6], 6, false);
		 //animation.play("open");
	 }
	 override public function update(elapsed:Float):Void
	 {
		 super.update(elapsed);
	 }
 }
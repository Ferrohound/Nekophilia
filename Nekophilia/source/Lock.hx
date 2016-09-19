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
	 }
 }
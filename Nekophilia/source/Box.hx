 package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;	
 
 class Box extends FlxSprite
 {

	//play smoke animation while dragged
	 public function new(?X:Float = 0, ?Y:Float = 0, index:Int){
		 super(X, Y);
		 loadGraphic("assets/images/lock.png", true, 64, 64);
		 //animation.add("open", [0, 1, 2, 3, 4, 5, 6], 6, false);
		 //animation.play("open");
		 acceleration.y = 600;
	 }
 }
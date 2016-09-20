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
		 if(index == 17)
			loadGraphic("assets/images/Box.png", false, 64, 64);
		if (index == 12)
			loadGraphic("assets/images/bigBox.png", false, 128, 128);
		 //animation.add("open", [0, 1, 2, 3, 4, 5, 6], 6, false);
		 //animation.play("open");
		 acceleration.y = 600;
		 drag.x = drag.y = 1100;
	 }
 }
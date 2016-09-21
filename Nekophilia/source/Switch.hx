package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;	
 
 class Switch extends Lock
 {
	 var _label:String;
	 public function new(state:PlayState, ?X:Float = 0, ?Y:Float = 0, Label:String = "A"){
		 super(state, X, Y);
		 loadGraphic("assets/images/switch.png", false, 64, 64);
		 _label = Label;
	 }
	 
	 //flip the opened value for each door
	 override public function unlock():Void
	 {
		 
	 }
	 
 }
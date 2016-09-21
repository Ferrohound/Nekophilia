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
	 public function new(state:PlayState, ?X:Float = 0, ?Y:Float = 0){
		 super(state, X, Y);
		 loadGraphic("assets/images/switch.png", false, 64, 64);
	 }
	 
	 //toggle the opened value for each door
	 //remove and add from_doors to disable collision
	 override public function unlock():Void
	 {
		SoundStore.unlock.play();
		for (i in _doors){
			i._open = !i._open;
			if (i._open == true){
				PlayState._doors.remove(i);
				i.loadGraphic("assets/images/alpha.png", false, 64, 64);
			}
			else{
				PlayState._doors.add(i);
				i.loadGraphic(i._graphic, true, 64, 64);
			}
		}
	 }
	 
	 public function unlockAll():Void
	 {
		 SoundStore.unlock.play();
		for (i in _doors){
			i._open = true;
			PlayState._doors.remove(i);
			i.loadGraphic("assets/images/alpha.png", false, 64, 64);
		}
	 }
	 
 }
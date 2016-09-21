package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;	
 import flixel.system.FlxSound;

 //script attached to the deer object to handle the slow
 //movement towards the player, and cross fade the music
 class ChaseLynx extends Deer
 {
	 public var _active:Bool = false;
	 public var _player1:Player1;
	 public var _player2:Player2;
	 public function new(?X:Float=0, ?Y:Float=0){
		 super(X, Y);
		 _player1 = PlayState._player1;
		 _player2 = PlayState._player2;
	 }
	 
	  override public function update(elapsed:Float): Void
	 {
		if ()
			_active = true;
		if (_active)
			//do the do
	 }
 }
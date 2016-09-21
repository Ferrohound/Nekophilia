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
	// public var _player1:Player1;
	 //public var _player2:Player2;
	 public function new(?X:Float=0, ?Y:Float=0){
		 super(X, Y);
	 }
	 
	  override public function update(elapsed:Float): Void
	 {
		if (getMidpoint().distanceTo(_player1.getMidpoint()) < _radius && getMidpoint().distanceTo(_player2.getMidpoint()) < _radius){
			if (_player1.x > x && _player2.x > x)
				_active = true;
			else{
				_active = false;
			}
		}
		if (_active)
			super.update(elapsed);
			
	}
 }
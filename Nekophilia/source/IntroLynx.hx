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
 class IntroLynx extends Deer
 {
	 public var _active:Bool = false;
	 public var _activated:Bool = false;
	 //public var _player1:Player1;
	 //public var _player2:Player2;
	 public function new(?X:Float=0, ?Y:Float=0){
		 super(X, Y);
	 }
	 
	  override public function update(elapsed:Float): Void
	 {
		 
		if (getMidpoint().distanceTo(_player1.getMidpoint()) < _radius && getMidpoint().distanceTo(_player2.getMidpoint()) < _radius){
			if (_player1.x > (x+64) && _player2.x > (x+64)){
				_active = true;
				_activated = true;
			}
		}
		else{
			_active = false;
		}
		
		if (_active){
			super.update(elapsed);
			if (getMidpoint().distanceTo(_player2.getMidpoint()) < (_radius / 3)){
				if(!PlayState._shadows.hasLightPoint(_player2.getMidpoint())){
					//_player2.kill();
					x = x;
				}
			}
		}
		if (!_active && _activated){
			SoundStore._stemB.fadeIn(3);
			SoundStore._stemC.fadeOut(3);
			
		}
	 }
 }
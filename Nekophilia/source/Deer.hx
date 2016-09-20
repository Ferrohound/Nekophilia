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
 class Deer extends FlxSprite
 {
	 var speed:Float = 50;
	 var factor:Float = 4;
	 
	 var _source:FlxObject;
	 var _spookStem:FlxSound;
	 var _defaultStem:FlxSound;
	 
	 var _radius = 200;
	 var _moveRadius = 50;
	 
	 var _player1:Player1;
	 var _player2:Player2;
	 
	 public function new(?X:Float=0, ?Y:Float=0,state:PlayState){
		 super(X, Y);
		 acceleration.y = 600;
		 _spookStem = state._stemC;
		 _spookStem.proximity(x, y, FlxG.camera.target, FlxG.width * 0.5);
		 _defaultStem = state._stemB;
		 
		 _spookStem.play();
		 
		 _player1 = state._player1;
		 _player2 = state._player2;
		 
		 drag.x = drag.y = 1100;
		 
		 loadGraphic("assets/images/lynx.png", true, 128, 128);
		 animation.add("move", [1, 2, 3, 4], 12, false);
		 
		 //for flipping the sprite when the player is facing other directions
		 setFacingFlip(FlxObject.LEFT, true, false);
		 setFacingFlip(FlxObject.RIGHT, false, false);
	 }
	 
	 //move the sprite closer to the closest player in
	 //the radius, modifying the audio as it gets closer
	 //only works in x direction
	 //also probably play some sort of particle system animation
	 override public function update(elapsed:Float): Void
	 {
		 _defaultStem.volume = 1-_spookStem.getActualVolume();
		//move towards player1
		if (getMidpoint().distanceTo(_player1.getMidpoint()) < _radius || getMidpoint().distanceTo(_player2.getMidpoint()) < _radius)
		{
			animation.play("move");
			if ((_player1.getMidpoint().distanceTo(getMidpoint())) < (_player2.getMidpoint().distanceTo(getMidpoint())))
			{
				_spookStem.proximity(x, y, _player1, FlxG.width * 0.7);
				if (_player1.x < x){
					facing = FlxObject.LEFT;
					acceleration.x = -speed;
					if (velocity.x < -speed){
						velocity.x = -speed;
					}
				}
				else{
					facing = FlxObject.RIGHT;
					acceleration.x = speed;
					if (velocity.x > speed){
						velocity.x = speed;
					}
				}
			}
		//move towards player2
			else{
				_spookStem.proximity(x, y, _player2, FlxG.width * 0.7);
				if (_player2.x < x){
					facing = FlxObject.LEFT;
					acceleration.x = -speed * factor;
					if (velocity.x < -speed){
						velocity.x = -speed;
					}
				}
				else{
					facing = FlxObject.RIGHT;
					acceleration.x = speed * factor;
					if (velocity.x > speed){
						velocity.x = speed;
					}
				}
			}
		}
		else{
			_spookStem.proximity(x, y, FlxG.camera.target, FlxG.width * 0.7);
			animation.reset();
			acceleration.x = 0;
			velocity.x = 0;
		}
		super.update(elapsed);
	 }
 }
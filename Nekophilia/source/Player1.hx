 package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;	

 class Player1 extends FlxSprite
 {
	 var speed:Float = 200;
	 
	 //orientation/angle
	 //used to set motion trajectory
	 var _rot: Float = 0;
	 
	 //keys pressed
	 var _up:Bool = false;
	 var _down:Bool = false;
	 var _left:Bool = false;
	 var _right:Bool = false;
	 
     public function new(?X:Float=0, ?Y:Float=0)
     {
         super(X, Y);
		 //loadGraphic file, animated?, frame width, frame height
		 //animation.add("name", array of frames, fps, loop)
		 //animation.play
		 //makeGraphic(32, 32, FlxColor.RED);
		 loadGraphic("assets/images/duck.png", true, 100, 114);
		 animation.add("walk", [0, 1, 0, 2], 5, true);
		 
		 //setFacingFlip(direction, flipx, flipy);
		 //for flipping the sprite when the player is facing other directions
		 setFacingFlip(FlxObject.LEFT, true, false);
		 setFacingFlip(FlxObject.RIGHT, false, false);
		 
		 drag.x = drag.y = 1100;
     }
	 
	 override public function update(elapsed:Float): Void
	 {
		 movement();
		 super.update(elapsed);
	 }
	 function movement(): Void
	 {
		 //use vectors instead?
		 _up = FlxG.keys.anyPressed([UP]);
		 _down = FlxG.keys.anyPressed([DOWN]);
		 _left = FlxG.keys.anyPressed([LEFT]);
		 _right = FlxG.keys.anyPressed([RIGHT]);
		 
		 //cancel out opposing directions
		 if (_up && _down){
			 _up = false;
			 _down = false;
			 //_up = _down = false;
		 }
		 
		 if (_left && _right)
			_left = _right = false;
			
		if (_up || _down || _left || _right) {
			
			if (_left){
				_rot = 180;
				//set sprite facing direction
				facing = FlxObject.LEFT;
				if (_up) _rot += 45;
				else if (_down) _rot -= 45;
			}
			else if (_right){
				_rot = 0;
				//get the sprite to face the right way
				facing = FlxObject.RIGHT;
				if (_up) _rot -= 45;
				else if (_down) _rot += 45;
			}
			else if (_down){
				//_rot = 90;
			}
			else if (_up && isTouching(FlxObject.FLOOR)){
				_rot = 270;
				velocity.y = -speed / 2;
			}
			
			
			velocity.set(speed);
			velocity.rotate(new FlxPoint(0, 0), _rot);
			
			if (velocity.x != 0){
				animation.play("walk");
			}
			else{
				animation.reset();
			}
		}
	 }
	 
 }
 package;

 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.math.FlxPoint;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;	

 class Player2 extends FlxSprite
 {
	 var speed:Float = 275;
	 
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
		 acceleration.x = 0;
		 //Use vectors instead?
		 _up = FlxG.keys.anyJustPressed([W]);
		 _down = FlxG.keys.anyPressed([S]);
		 _left = FlxG.keys.anyPressed([A]);
		 _right = FlxG.keys.anyPressed([D]);
		 
		 //cancel out opposing directions
		 if (_left && _right)
			_left = _right = false;
			
		if (_up || _down || _left || _right) {
			
			if (_left){
				_rot = 180;
				//set sprite facing direction
				facing = FlxObject.LEFT;
				acceleration.x = -speed * 4;
				if (velocity.x < -speed){
					velocity.x = -speed;
				}
			}
			else if (_right){
				_rot = 0;
				//get the sprite to face the right way
				facing = FlxObject.RIGHT;
				acceleration.x = speed * 4;
				if (velocity.x < -speed){
					velocity.x = speed;
				}
			}
			if (_down){
				//_rot = 90;
			}
			if (_up&& isTouching(FlxObject.FLOOR)){
				//_rot = 270;
				velocity.y = -speed;
			}
			//velocity.set(speed);
			//velocity.rotate(new FlxPoint(0, 0), _rot);
		}
		if (acceleration.x != 0){
			animation.play("walk");
		}
		else{
			animation.reset();
		}
	 }
	 
 }
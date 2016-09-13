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
	 private var shadows : ShadowSystem;
	 
	 var speed:Float = 200;
	 
	 //orientation/angle
	 //used to set motion trajectory
	 var _rot: Float = 0;
	 
	 //keys pressed
	 var _up:Bool = false;
	 var _down:Bool = false;
	 var _left:Bool = false;
	 var _right:Bool = false;
	 
     public function new(?X:Float=0, ?Y:Float=0, shadows:ShadowSystem)
     {
         super(X, Y);
		 this.shadows = shadows;
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
		 shadows.addLightPoint(getMidpoint());
	 }
	 function movement(): Void
	 {
		acceleration.x = 0;
		//Use vectors instead?
		_up = FlxG.keys.anyJustPressed([UP]);
		_down = FlxG.keys.anyPressed([DOWN]);
		_left = FlxG.keys.anyPressed([LEFT]);
		_right = FlxG.keys.anyPressed([RIGHT]);
		
		var factor = if (isTouching(FlxObject.FLOOR)) 4; else 1;
		
		//cancel out opposing directions
		if (_left && _right)
			_left = _right = false;
			
		if (_up || _down || _left || _right) {
			
			if (_left){
				_rot = 180;
				//set sprite facing direction
				facing = FlxObject.LEFT;
				acceleration.x = -speed * factor;
				
				if (velocity.x < -speed){
					velocity.x = -speed;
				}
			}
			else if (_right){
				_rot = 0;
				//get the sprite to face the right way
				facing = FlxObject.RIGHT;
				acceleration.x = speed * factor;
				
				if (velocity.x > speed){
					velocity.x = speed;
				}
			}
			if (_down){
				//_rot = 90;
			}
			if (_up&& isTouching(FlxObject.FLOOR)){
				//_rot = 270;
				velocity.y = -400;
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
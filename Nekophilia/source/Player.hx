package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxObject;	

class Player extends FlxSprite
{
	public var acceptInput = true;
	
	public var speed    :Float = 200;
	public var jumpSpeed:Float = 500;
	
	var _upKey   :FlxKey;
	var _downKey :FlxKey;
	var _leftKey :FlxKey;
	var _rightKey:FlxKey;
	
	//keys pressed
	var _up   :Bool = false;
	var _down :Bool = false;
	var _left :Bool = false;
	var _right:Bool = false;
	
	//added third argument to the constructor, "W" for WASD, "A" for Arrows
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		
		collisonXDrag = true;
		
		//setFacingFlip(direction, flipx, flipy);
		//for flipping the sprite when the player is facing other directions
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		drag.x = drag.y = 1100;
	}
	
	public function setControls(up:FlxKey, down:FlxKey, left:FlxKey, right:FlxKey)
	{
		_upKey    = up;
		_downKey  = down;
		_leftKey  = left;
		_rightKey = right;
	}
	
	override public function update(elapsed:Float): Void
	{
		movement();
		super.update(elapsed);
	}
	
	function movement(): Void
	{
		acceleration.x = 0;
		
		_up = FlxG.keys.anyPressed([_upKey]);
		_down = FlxG.keys.anyPressed([_downKey]);
		_left = FlxG.keys.anyPressed([_leftKey]);
		_right = FlxG.keys.anyPressed([_rightKey]);
		
		//cancel out opposing directions
		if (_left && _right)
			_left = _right = false;
			
		if (acceptInput && (_up || _down || _left || _right)) {
			
			var factor = 1;
			if (isTouching(FlxObject.FLOOR)) {
				if (_down) {
					factor = 1;
				} else {
					factor = 4;
				}
			}
			
			if (_left) {
				//set sprite facing direction
				facing = FlxObject.LEFT;
				acceleration.x = -speed * factor;
				
				if (velocity.x < -speed) {
					velocity.x = -speed;
				}
			} else if (_right) {
				//get the sprite to face the right way
				facing = FlxObject.RIGHT;
				acceleration.x = speed * factor;
				
				if (velocity.x > speed){
					velocity.x = speed;
				}
			}
			if (_up && isTouching(FlxObject.FLOOR)) {
				velocity.y = -jumpSpeed;
			}
			
		}
		
		if (acceleration.x != 0) {
			animation.play("walk");
		} else {
			animation.reset();
		}
	}
	
	public function beforeCollideTerrain()
	{
		allowCollisions = FlxObject.ANY;
	}
	
	public function beforeCollidePlayer()
	{
		if (_down && isTouching(FlxObject.FLOOR)) {
			allowCollisions = FlxObject.UP | FlxObject.DOWN;
		} else {
			allowCollisions = FlxObject.DOWN;
		}
	}
	
}
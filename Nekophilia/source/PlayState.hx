package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import openfl.Assets;
//	var gameWidth:Int = 320; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
//	var gameHeight:Int = 240; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
class PlayState extends FlxState
{
	//two player objects, one controlled by WASD one by the arrow keys
	//look into Haxe inheritance 
	var _player1:Player1;
	var _player2:Player2;
	//midpoint game object for camera
	var _midPoint:FlxObject;
	
	var _shadows:ShadowSystem;
	
	private var _level:FlxTilemap;
	
	//Flixel groups
	//use collide to prevent them from walking into it
	//then overlap + function to call
	private var _doors:FlxTypedGroup<Door>;
	//_doors.add(new Door());
	//private var _shakeTriggers:FlxTypedGroup<shakeTrigger>;
	
	
	override public function create():Void
	{
		
		bgColor = FlxColor.RED;
		
		//extend camera size so when the screen shakes
		//you don't see the black
		var ext = 100;
        FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
		
		//make the mouse invisible
		//FlxG.mouse.visible = false;
		
		//get the level, commented out is another method to be investigated
		//the value 8 in the csv file seems to slow down the PCs
		/*
		var tileMap:FlxTilemap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/my-map-data.csv");
        var mapTilePath:String = "assets/images/my-map-tilesheet.png";
        tileMap.loadMap(mapData, mapTilePath, 16, 16);
        add(tileMap);
		 */
		_level = new FlxTilemap();
		_level.loadMapFromCSV("assets/images/test.csv", FlxGraphic.fromClass(GraphicAuto), 0, 0);
		add(_level);
		
		//shadow system
		_shadows = new ShadowSystem([]);
		
		//add the two players to the game
		_player1 = new Player1(10, 10, _shadows);
		add(_player1);
		_player2 = new Player2(20, 10);
		add(_player2);
		
		//set midpoint game object
		_midPoint = new FlxObject((_player1.x + _player2.x)/2,(_player1.y + _player2.y)/2,_player1.width,_player1.height);
		FlxG.camera.follow(_midPoint, PLATFORMER);
		//setting gravity
		_player1.acceleration.y = _player2.acceleration.y = 600;
		
		add(_shadows);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{		
		//update the position of the midPoint object for the camera
		_midPoint.x = ((_player1.x + _player2.x) / 2);
		_midPoint.y = ((_player1.y + _player2.y) / 2);
		
		//getting the right offset for the shadows + light
		//in this case, 100 is used as the screen extension
		var tmp = _midPoint.getMidpoint();
		//tmp.x -= ((FlxG.width + 100) / 2);
		//tmp.y -= ((FlxG.height+100) / 2);
		
		_shadows.beginLights(tmp);
		_shadows.addLight(700, 1600, 1000);
		_shadows.addLight(1200, 200, 130);
		
		super.update(elapsed);
		FlxG.collide(_level, _player1);
		FlxG.collide(_level, _player2);
		
		//use p1 as a platform?
		var _down = FlxG.keys.anyPressed([DOWN]);
		if (_down)
			FlxG.collide(_player1, _player2);
		
		/*
		//for handling groups, collision and win condition
		FlxG.collide(_doors, _player2);
		//or do lockpicking from p2's code, isTouching()
		FlxG.overlap(_doors, _player2, lockpick);
		FlxG.overlap(_clues, _player1, displayClue);
		
		FlxG.overlap(_exit, _player1, win);
		FlxG.overlap(_exit, _player2, win);
		 */
		
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
	//method to call for simple camera shake
	//and simple camera flash
	function shake():Void
	{
		var duration = 0.5;
		FlxG.camera.shake(0.01, duration);
		//white flash
		FlxG.camera.flash(0xFFFFFFFF, duration);
	}
}

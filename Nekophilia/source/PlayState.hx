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
import flixel.group.FlxGroup;

import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlayState extends FlxState
{
	//two player objects, one controlled by WASD one by the arrow keys
	//look into Haxe inheritance 
	var _player1:Player1;
	var _player2:Player2;
	//midpoint game object for camera
	var _midPoint:FlxObject;
	
	var _shadows :ShadowSystem;
	var _dialogue:DialogueBox;
	
	//group of flxObject to trigger death; attained from the tiled map
	public var _dead:FlxGroup;
	
	private var _level:TiledLevel;
	var BtileMap:FlxTilemap;
	var FtileMap:FlxTilemap;
	
	//Flixel groups
	//use collide to prevent them from walking into it
	//then overlap + function to call
	
	//group for the little doors
	//group for the big doors
	public var _Bboxes:FlxGroup;
	public var _LBoxes:FlxGroup;
	//the exit door
	public var _exit:FlxSprite;
	
	//private var _shakeTriggers:FlxTypedGroup<shakeTrigger>;
	
	
	override public function create():Void
	{
		bgColor = 0xffaaaaaa;
		_Bboxes = new FlxGroup();
		_LBoxes = new FlxGroup();
		_dead = new FlxGroup();
		bgColor = FlxColor.RED;
		
		//extend camera size so when the screen shakes
		//you don't see the black
		var ext = 100;
        FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
		//make the mouse invisible
		//FlxG.mouse.visible = false;
		
		
		BtileMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/Level_Background.csv");
        var mapTilePath:String = "assets/data/Wood.png";
        BtileMap.loadMapFromCSV(mapData, mapTilePath, 64, 64);
        add(BtileMap);
		
		FtileMap = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Foreground.csv");
        mapTilePath = "assets/data/Brick.png";
        FtileMap.loadMapFromCSV(mapData, mapTilePath, 64, 64);
        add(FtileMap);
		
		FlxG.camera.setScrollBoundsRect(0, 0, FtileMap.width, FtileMap.height, true);
		
		//loading the level in with the Tiled file as input
		//_level = new TiledLevel("assets/data/Level.tmx", this);
		//add(_level.backgroundLayer);
		//add(_level.objectsLayer);
		//add(_level.foregroundTiles);
		
		add(_Bboxes);
		add(_LBoxes);
		add(_dead);
		
		
		//_level = new FlxTilemap();
		//_level.loadMapFromCSV("assets/images/test.csv", FlxGraphic.fromClass(GraphicAuto), 0, 0);
		//add(_level);
		
		_shadows = new ShadowSystem();
		
		//add the two players to the game
		_player1 = new Player1(128, 180, _shadows);
		add(_player1);
		_player2 = new Player2(128, 180);
		add(_player2);
		
		//set midpoint game object
		_midPoint = new FlxObject((_player1.x + _player2.x)/2,(_player1.y + _player2.y)/2,_player1.width,_player1.height);
		FlxG.camera.follow(_midPoint, PLATFORMER);
		//setting gravity
		_player1.acceleration.y = _player2.acceleration.y = 600;
		
		add(_shadows);
		
		_dialogue = new DialogueBox();
		add(_dialogue);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{		
		//update the position of the midPoint object for the camera
		_midPoint.x = ((_player1.x + _player2.x) / 2);
		_midPoint.y = ((_player1.y + _player2.y) / 2);
		
		var tmp = _midPoint.getMidpoint();
		
		_shadows.beginLights(tmp);
		//_shadows.addLight(700, 1600, 1000);
		//_shadows.addLight(1200, 200, 130);
		
		super.update(elapsed);
		
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
		
		//FlxG.overlap(_exit, _player1, ending);
		//FlxG.overlap(_exit, _player2, ending);
		
		if (FlxG.keys.anyJustPressed([ENTER])) {
			_dialogue.showScript(Assets.getText("assets/text/1-arrive.txt"), null, [shake]);
		}
		if (FlxG.keys.anyJustPressed([ESCAPE])) {
			_dialogue.showScript();
		}
		
		FlxG.collide(FtileMap, _player1);
		FlxG.collide(FtileMap, _player2);
		//Script for colliding the level with the player
		// Collide with foreground tile layer
		//_level.collideWithLevel(_player1);
		//_level.collideWithLevel(_player2);
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
	
	public function ending(Exit:FlxObject, Player:FlxObject):Void
	{
		//do final cutscene stuff
		_player1.kill();
		_player2.kill();
	}
}

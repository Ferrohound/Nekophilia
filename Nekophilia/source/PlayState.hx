package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlayState extends FlxState
{
	//two player objects, one controlled by WASD one by the arrow keys
	//look into Haxe inheritance 
	public var _player1:Player1;
	public var _player2:Player2;
	public var TMP:Deer;
	//midpoint game object for camera
	var _midPoint:FlxObject;
	
	var _shadows :ShadowSystem;
	var _dialogue:DialogueBox;
	
	//group of flxObject to trigger death; attained from the tiled map
	
	
	//tilemaps
	var BtileMap:FlxTilemap;
	var FtileMap:FlxTilemap;
	var Foreground:FlxTilemap;
	var Objects:FlxTilemap;
	
	//Flixel groups
	//use collide to prevent them from walking into it
	//then overlap + function to call
	
	//group for the little doors
	//group for the big doors
	public var _Bboxes:FlxGroup;
	public var _LBoxes:FlxGroup;
	public var _deer:FlxGroup;
	public var _locks:FlxGroup;
	public var _dead:FlxGroup;
	public var _candles:FlxGroup;
	//the exit door
	public var _exit:FlxSprite;
	
	//audio stems
	public var _stemA:FlxSound;
	public var _stemB:FlxSound;
	public var _stemC:FlxSound;
	public var _stemD:FlxSound;
	public var _stemE:FlxSound;
	public var _stemF:FlxSound;
	public var _stemG:FlxSound;
	
	public var _aVoice:FlxSound;
	public var _oVoice:FlxSound;
	
	public var _boxDrag:FlxSound;
	
	public var _AleftFoot:FlxSound;
	public var _ArightFoot:FlxSound;
	public var _OleftFoot:FlxSound;
	public var _OrightFoot:FlxSound;
	
	
	//private var _shakeTriggers:FlxTypedGroup<shakeTrigger>;
	
	
	override public function create():Void
	{
		bgColor = 0xffaaaaaa;
		
		_Bboxes = new FlxGroup();
		_LBoxes = new FlxGroup();
		_dead = new FlxGroup();
		_deer = new FlxGroup();
		_locks = new FlxGroup();
		_candles = new FlxGroup();
		
		bgColor = FlxColor.RED;
		
		//extend camera size so when the screen shakes
		//you don't see the black
		var ext = 100;
        FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
		//make the mouse invisible
		FlxG.mouse.visible = false;
		
		loadAudio();
		_stemB.play();
		
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
		
		//load the required objects
		Objects = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Object.csv");
        mapTilePath = "assets/data/Misc.png";
        Objects.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		loadObjects();
        add(Objects);
		
		//do nothing with the foreground :')
		Foreground = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_FORE.csv");
        mapTilePath = "assets/data/Misc.png";
        Foreground.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		
		FlxG.camera.setScrollBoundsRect(0, 0, FtileMap.width, FtileMap.height, true);
		
		//loading the level in with the Tiled file as input
		//_level = new TiledLevel("assets/data/Level.tmx", this);
		//add(_level.backgroundLayer);
		//add(_level.objectsLayer);
		//add(_level.foregroundTiles);
		
		add(_Bboxes);
		add(_LBoxes);
		
		//add the deer to the game
		
		add(_dead);
		//iterate over all the deer and create Deer objects
		add(_deer);
		
		
		//_level = new FlxTilemap();
		//_level.loadMapFromCSV("assets/images/test.csv", FlxGraphic.fromClass(GraphicAuto), 0, 0);
		//add(_level);
		
		_shadows = new ShadowSystem();
		
		//add the two players to the game
		_player1 = new Player1(128, 320, _shadows);
		add(_player1);
		_player2 = new Player2(182, 320);
		add(_player2);
		
		//set midpoint game object
		_midPoint = new FlxObject((_player1.x + _player2.x)/2,(_player1.y + _player2.y)/2,_player1.width,_player1.height);
		FlxG.camera.follow(_midPoint, PLATFORMER);
		//setting gravity
		_player1.acceleration.y = _player2.acceleration.y = 600;
		
		add(Foreground);
		add(_shadows);
		
		_dialogue = new DialogueBox(["Owen"=>_oVoice, "Aimee"=>_aVoice]);
		add(_dialogue);
		
		//TMP = new Deer(500, 320, this);
		
		super.create();
	}
	
	function loadObjects():Void
	{
		var deathCoords:Array<FlxPoint> = Objects.getTileCoords(24, false);
		
		//add the death spots to the game
		for (point in deathCoords){
			var tmp = new FlxObject(point.x, point.y, 64, 64);
			_dead.add(tmp);
		}
		
		//add the locks
		var lockCoords:Array<FlxPoint> = Objects.getTileCoords(2, false);
		for (point in lockCoords){
			var tmp = new Lock(this, point.x, point.y);
			_locks.add(tmp);
		}
		//remove the lock sprites
		var lockSprites:Array<Int> = Objects.getTileInstances(2);
		for (i in 0...8){
			//var lockSprite:Int = lockSprites[i];
			//Objects.setTileByIndex(lockSprite, -1, true);	
		}
		
		//add the doors
		
		//add small boxes
		var sBoxCoords:Array<FlxPoint> = Objects.getTileCoords(17, false);
		for (point in sBoxCoords){
			var tmp = new Box(point.x, point.y,17);
			_LBoxes.add(tmp);
		}
		//remove the box sprites
		
		//add big boxes
		var bBoxCoords:Array<FlxPoint> = Objects.getTileCoords(12, false);
		for (point in bBoxCoords){
			var tmp = new Box(point.x, point.y,12);
			_Bboxes.add(tmp);
		}
		//remove the box sprites
		
		
		//add the candles
		var candleCoords:Array<FlxPoint> = Objects.getTileCoords(8, false);
		for (point in candleCoords){
			var tmp = new Candle(_shadows, point.x, point.y);
		}
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
		FlxG.overlap(_dead, _player1, dead);
		FlxG.overlap(_dead, _player2, dead);
		
		//start unlock sequence
		if(FlxG.keys.anyJustPressed([E])){
			FlxG.overlap(_locks, _player2, unlock);
		}
		if (FlxG.keys.anyJustPressed([CONTROL])){
			FlxG.overlap(_candles, _player1, lightCandle);
		}
		
		if (FlxG.keys.anyJustPressed([ENTER])) {
			_dialogue.showScript(Assets.getText("assets/text/main/arrive.txt"), null, [shake]);
		}
		if (FlxG.keys.anyJustPressed([ESCAPE])) {
			_dialogue.showScript();
		}
		
		FlxG.collide(FtileMap, _player1);
		FlxG.collide(FtileMap, _player2);
		FlxG.collide(FtileMap, TMP);
		
		//collide with boxes
		FlxG.collide(_LBoxes, _player1);
		FlxG.collide(_LBoxes, _player2);
		FlxG.collide(_Bboxes, _player1);
		FlxG.collide(_Bboxes, _player2);
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
	
	public function dead(Dead:FlxObject, Player:FlxObject): Void
	{
		_player1.kill();
		_player2.kill();
		FlxG.resetState();
	}
	public function lightCandle(candle:FlxObject, Player:FlxObject): Void
	{
		//light the candle
	}
	
	public function ending(Exit:FlxObject, Player:FlxObject):Void
	{
		//do final cutscene stuff
		_player1.kill();
		_player2.kill();
	}
	
	public function unlock(LOCK:FlxObject,Player:FlxObject):Void{
		//do the unlocking minigame
	}
	
	//self explanatory
	function loadAudio():Void
	{
		#if flash
		_stemA = FlxG.sound.load(AssetPaths.A_Base_Stem__mp3);
		_stemB = FlxG.sound.load(AssetPaths.B_Melody_Stem__mp3);
		_stemC = FlxG.sound.load(AssetPaths.C_MonsterApproach_Stem__mp3);
		_stemD = FlxG.sound.load(AssetPaths.D_Piano_Stem__mp3);
		_stemE= FlxG.sound.load(AssetPaths.E_Abrasive_Stem__mp3);
		_stemF = FlxG.sound.load(AssetPaths.F_Monster_Creeping_Stem__mp3);
		_stemG = FlxG.sound.load(AssetPaths.G_Soundscape_Stem__mp3);
		
		_aVoice = FlxG.sound.load(AssetPaths.Aimee_Voice_Sample__mp3);
		_oVoice =FlxG.sound.load(AssetPaths.Owen_Voice_Sample__mp3);
		
		_boxDrag =FlxG.sound.load(AssetPaths.Spooky_Box_Drag__mp3);
		
		_AleftFoot =FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_1__mp3);
		_ArightFoot =FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_2__mp3);
		_OleftFoot = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_1__mp3);
		_OrightFoot = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_2__mp3);
		#else
		_stemA = FlxG.sound.load(AssetPaths.A_Base_Stem__ogg);
		_stemB = FlxG.sound.load(AssetPaths.B_Melody_Stem__ogg);
		_stemC = FlxG.sound.load(AssetPaths.C_MonsterApproach_Stem__ogg);
		_stemD = FlxG.sound.load(AssetPaths.D_Piano_Stem__ogg);
		_stemE = FlxG.sound.load(AssetPaths.E_Abrasive_Stem__ogg);
		_stemF = FlxG.sound.load(AssetPaths.F_Monster_Creeping_Stem__ogg);
		_stemG = FlxG.sound.load(AssetPaths.G_Soundscape_Stem__ogg);
		
		_aVoice = FlxG.sound.load(AssetPaths.Aimee_Voice_Sample__ogg);
		_oVoice =FlxG.sound.load(AssetPaths.Owen_Voice_Sample__ogg);
		
		_boxDrag =FlxG.sound.load(AssetPaths.Spooky_Box_Drag__ogg);
		
		_AleftFoot =FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_1__ogg);
		_ArightFoot =FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_2__ogg);
		_OleftFoot = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_1__ogg);
		_OrightFoot = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_2__ogg);
		#end
	}
}

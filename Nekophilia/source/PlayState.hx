package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;


class PlayState extends FlxState
{
	public static var inst(default, null):PlayState;
	
	//two player objects, one controlled by WASD one by the arrow keys
	public static var _player1(default, null):Player1;
	public static var _player2(default, null):Player2;
	//midpoint game object for camera
	var _midPoint:FlxObject;
	
	public static var _shadows (default, null):ShadowSystem;
	public static var _dialogue(default, null):DialogueBox;
	
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
	public static var _boxes:FlxTypedGroup<Box>;
	public static var _smoke:FlxTypedGroup<SmokeParticle>;
	public static var _deer:FlxTypedGroup<Deer>;
	public static var _locks:FlxTypedGroup<Lock>;
	public static var _candles:FlxTypedGroup<Candle>;
	public static var _dead:FlxGroup;
	//the exit door
	public static var _exit:FlxSprite;
	
	//triggers
	public static var _startTrigger:FlxGroup;
	public static var _monsterChase:FlxObject;
	public static var _monsterEscape:FlxObject;
	
	
	override public function create():Void
	{
		inst = this;
		
		bgColor = 0xffaaaaaa;
		
		_boxes   = new FlxTypedGroup<Box>();
		_smoke   = new FlxTypedGroup<SmokeParticle>();
		_deer    = new FlxTypedGroup<Deer>();
		_locks   = new FlxTypedGroup<Lock>();
		_candles = new FlxTypedGroup<Candle>();
		_dead = new FlxGroup();
		_startTrigger = new FlxGroup();
		
		_shadows = new ShadowSystem(FlxColor.BLACK);
		
		bgColor = FlxColor.RED;
		
		//extend camera size so when the screen shakes
		//you don't see the black
		var ext = 100;
        FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
		//make the mouse invisible
		FlxG.mouse.visible = false;
		
		SoundStore.loadAudio();
		
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
		
		//have to create players first
		_player1 = new Player1(128, 320);
		_player1.lanternLit = false;
		_player1.acceptInput = false;
		
		_player2 = new Player2(182, 320);
		_player2.acceptInput = false;
		
		loadObjects();
        add(Objects);
		
		//do nothing with the foreground :')
		Foreground = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_FORE.csv");
        mapTilePath = "assets/data/Misc.png";
        Foreground.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		
		FlxG.camera.setScrollBoundsRect(0, 0, FtileMap.width, FtileMap.height, true);
		
		add(_boxes);
		
		//add the deer to the game
		
		add(_dead);
		//iterate over all the deer and create Deer objects
		add(_deer);
		add(_locks);
		add(_candles);
		
		//add the two players to the game
		add(_player1);
		add(_player2);
		
		add(_smoke);
		
		//set midpoint game object
		_midPoint = new FlxObject((_player1.x + _player2.x)/2,(_player1.y + _player2.y)/2,_player1.width,_player1.height);
		FlxG.camera.follow(_midPoint, PLATFORMER);
		
		_deer.add(new Deer(500, 320));
		
		add(Foreground);
		add(_shadows);
		add(_startTrigger);
		
		_dialogue = new DialogueBox(["Owen"=>SoundStore.voiceOwen, "Aimee"=>SoundStore.voiceAimee]);
		add(_dialogue);
		
		_dialogue.showScript(
			Assets.getText("assets/text/main/arrive.txt"),
			"arrive",
			function(f, o, d) : Bool
			{
				//Fade in from black
				FlxG.camera.flash(FlxColor.BLACK, 3);
				_player1.lanternLit = true;
				_player1.acceptInput = true;
				_player2.acceptInput = true;
				_shadows.shadowColor = ShadowSystem.DEF_SHADOW_COLOR;
				return true;
			}
		);
		
		super.create();
	}
	
	public static inline var TILE_DEATH     = 24;
	public static inline var TILE_LOCK      =  2;
	public static inline var TILE_BOX_SM    = 17;
	public static inline var TILE_BOX_LG    = 12;
	public static inline var TILE_CANDLE    =  8;
	public static inline var TILE_START_TRG = 11;
	public static inline var TILE_LYNX      = 18;
	
	function loadObjects():Void
	{
		//add the death spots to the game
		for (point in Objects.getTileCoords(TILE_DEATH, false)){
			_dead.add(new FlxObject(point.x, point.y, 64, 64));
		}
		
		//add the locks
		for (point in Objects.getTileCoords(TILE_LOCK, false)){
			_locks.add(new Lock(this, point.x, point.y));
		}
		//remove the lock sprites
		for (i in Objects.getTileInstances(TILE_LOCK)){
			Objects.setTileByIndex(i, -1, true);
		}
		
		//add the doors
		/*
		 * 
		 * 
		 * 
		 */
		//add small boxes
		for (point in Objects.getTileCoords(TILE_BOX_SM, false)){
			_boxes.add(new Box(point.x, point.y, false));
		}
		//remove the box sprites
		for (i in Objects.getTileInstances(TILE_BOX_SM)){
			Objects.setTileByIndex(i, -1, true);
		}
		
		//add big boxes
		for (point in Objects.getTileCoords(TILE_BOX_LG, false)){
			_boxes.add(new Box(point.x, point.y, true));
		}
		//remove the box sprites
		for (i in Objects.getTileInstances(TILE_BOX_LG)){
			Objects.setTileByIndex(i, -1, true);
		}
		
		
		//add the candles
		for (point in Objects.getTileCoords(TILE_CANDLE, false)){
			_candles.add(new Candle(_shadows, point.x, point.y));
		}
		//remove candle sprites
		for (i in Objects.getTileInstances(TILE_CANDLE)){
			Objects.setTileByIndex(i, -1, true);
		}
		
		//load in start trigger
		for (point in Objects.getTileCoords(TILE_START_TRG, false)){
			_startTrigger.add(new FlxObject(point.x, point.y, 64, 64));
		}
		
		//add lynx
		for (point in Objects.getTileCoords(TILE_LYNX, false)){
			_deer.add(new Deer(point.x, point.y));
		}
		for (i in Objects.getTileInstances(TILE_LYNX)){
			Objects.setTileByIndex(i, -1, true);
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
		
		/*
		//for handling groups, collision and win condition
		FlxG.collide(_doors, _player2);
		//or do lockpicking from p2's code, isTouching()
		FlxG.overlap(_doors, _player2, lockpick);
		FlxG.overlap(_clues, _player1, displayClue);
		
		FlxG.overlap(_exit, _player1, win);
		FlxG.overlap(_exit, _player2, win);
		 */
		
		FlxG.overlap(_dead, _player1, dead);
		FlxG.overlap(_dead, _player2, dead);
		FlxG.overlap(_startTrigger, _player1, StrtTrig);
		FlxG.overlap(_startTrigger, _player2, StrtTrig);
		
		if (FlxG.keys.anyJustPressed([ESCAPE])) {
			if (_dialogue.alive) _dialogue.showScript();
		}
		
		_player1.beforeCollideTerrain();
		_player2.beforeCollideTerrain();
		
		//collide with boxes
		FlxG.collide(FtileMap, _boxes);
		FlxG.collide(_boxes, _player1);
		FlxG.collide(_boxes, _player2);
		
		FlxG.collide(FtileMap, _player1);
		FlxG.collide(FtileMap, _player2);
		
		FlxG.collide(_boxes, _deer);
		FlxG.collide(FtileMap, _deer);
		
		FlxG.collide(FtileMap, _boxes);
		
		_player1.beforeCollidePlayer();
		_player2.beforeCollidePlayer();
		
		FlxG.collide(_player1, _player2);
	}
	
	function StrtTrig(thing:FlxObject, player:FlxObject):Void
	{
		if (!SoundStore._stemB.playing) SoundStore._stemB.fadeIn(3);
		thing.kill();
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
	
	public function dead(dead:FlxObject, player:FlxObject): Void
	{
		player.kill();
	}
	
	public function ending(Exit:FlxObject, Player:FlxObject):Void
	{
		//do final cutscene stuff
		_player1.kill();
		_player2.kill();
	}
}

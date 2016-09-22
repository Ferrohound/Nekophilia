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
	//omni-switch
	var _omni:FlxObject;
	var _switch:Switch;
	
	//tilemaps
	var BtileMap:FlxTilemap;
	var FtileMap:FlxTilemap;
	var Foreground:FlxTilemap;
	var Objects:FlxTilemap;
	
	//maps for the keys/switches and their corresponding doors
	var switchMap:FlxTilemap;
	var Lock1:FlxTilemap;
	var Lock2:FlxTilemap;
	var Lock3:FlxTilemap;
	var Lock4:FlxTilemap;
	var Lock5:FlxTilemap;
	var Lock6:FlxTilemap;
	var Lock7:FlxTilemap;
	var Lock8:FlxTilemap;
	
	//Lynxes
	var ILynx:IntroLynx;
	var CLynx:ChaseLynx;
	
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
	public static var _doors:FlxTypedGroup<Door>;
	//the exit door
	public static var _exit:FlxSprite;
	
	public static var _locksDone:Int = 0;
	
	//triggers
	public static var _startTrigger:FlxGroup;
	public static var _crouchDialogueTrigger:FlxGroup;
	public static var _lockDialogueTrigger:FlxGroup;
	public static var _monsterChase:FlxObject;
	public static var _monsterEscape:FlxObject;
	
	
	override public function create():Void
	{
		SoundStore.loadAudio();
		inst = this;
		
		bgColor = 0xffaaaaaa;
		
		_boxes   = new FlxTypedGroup<Box>();
		_smoke   = new FlxTypedGroup<SmokeParticle>();
		_deer    = new FlxTypedGroup<Deer>();
		_locks   = new FlxTypedGroup<Lock>();
		_candles = new FlxTypedGroup<Candle>();
		_doors   = new FlxTypedGroup<Door>();
		
		_dead = new FlxGroup();
		_startTrigger = new FlxGroup();
		_crouchDialogueTrigger = new FlxGroup();
		_lockDialogueTrigger   = new FlxGroup();
		
		_shadows = new ShadowSystem(FlxColor.BLACK);
		
		bgColor = FlxColor.RED;
		
		//extend camera size so when the screen shakes
		//you don't see the black
		var ext = 100;
        FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
		//make the mouse invisible
		FlxG.mouse.visible = false;
		
		BtileMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/Level_Background.csv");
        var mapTilePath:String = "assets/data/Wood.png";
        BtileMap.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		
		var i:Int = 48;
		while (true){
			for (point in BtileMap.getTileCoords(i, false)){
				if (i < 58){
					//inscription 3
				}
				else if (i < 70){
					//inscription 1
				}
				else{
					//inscription 2
				}
			}
			
			i++;
			if (i==51||i==57||i == 63 || i == 69 || i == 75){
				i += 3;
			}
			if (i == 81)
				break;
		}
		
		for (point in BtileMap.getTileCoords(2, false)){
			//spot right before the first lock
			_lockDialogueTrigger.add(new FlxObject(point.x, point.y, 64, 64)); 
		}
		
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
		
		
		loadLocks();
		loadSwitch();
		
		loadObjects();
		add(ILynx);
		add(CLynx);
		
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
		add(_omni);
		add(_locks);
		add(Objects);
		add(_candles);
		add(_doors);
		
		//add the two players to the game
		add(_player1);
		add(_player2);
		
		add(_smoke);
		
		//set midpoint game object
		_midPoint = new FlxObject((_player1.x + _player2.x)/2,(_player1.y + _player2.y)/2,_player1.width,_player1.height);
		FlxG.camera.follow(_midPoint, PLATFORMER);
		
		add(Foreground);
		add(_shadows);
		_deer.add(new Deer(500, 320));
		add(_startTrigger);
		add(_crouchDialogueTrigger);
		add(_lockDialogueTrigger);
		
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
	public static inline var TILE_CRCH_TRG  = 26;
	
	//loading all of the Key-door maps
	function loadLocks():Void
	{
		Lock1 = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/Level_Lock1.csv");
        var mapTilePath:String = "assets/data/Misc.png";
        Lock1.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock1, 1);
		Lock1 = null;
		
		Lock2 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock2.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock2.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock2, 2);
		Lock2 = null;
		
		Lock3 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock3.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock3.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock3, 3);
		Lock3 = null;
		
		Lock4 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock4.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock4.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock4, 4);
		Lock4 = null;
		
		Lock5 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock5.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock5.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock5, 5);
		Lock5 = null;
		
		Lock6 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock6.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock6.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock6, 6);
		Lock6 = null;
		
		Lock7 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock7.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock7.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock7, 7);
		Lock7 = null;
		
		Lock8 = new FlxTilemap();
        mapData = Assets.getText("assets/data/Level_Lock8.csv");
        mapTilePath = "assets/data/Misc.png";
        Lock8.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		createLocks(Lock8, 8);
		Lock8 = null;
	}
	
	//create the key-door game objects
	function createLocks(lockMap:FlxTilemap, i:Int):Void
	{
		//add the locks
		for (point in lockMap.getTileCoords(TILE_LOCK, false)){
			var lock = new Lock(this, point.x, point.y);
			_locks.add(lock);
			
			//load the door(s)
			if (i > 2){
				for (point in lockMap.getTileCoords(27, false)){
				var door = new Door(point.x, point.y, false, 27);
				lock._doors.add(door);
				_doors.add(door);
				}
				for (i in lockMap.getTileInstances(27)){
				lockMap.setTileByIndex(i, -1, true);
				}
			}
			if (i<3){
				for (point in lockMap.getTileCoords(28, false)){
				var door = new Door(point.x, point.y, false,28);
				lock._doors.add(door);
				_doors.add(door);
				}
				//push the door onto the locks _doors
				for (i in lockMap.getTileInstances(28)){
					lockMap.setTileByIndex(i, -1, true);
				}
			}
		}
		//remove the lock sprites
		for (i in lockMap.getTileInstances(TILE_LOCK)){
			lockMap.setTileByIndex(i, -1, true);
		}
	}
	
	function loadSwitch():Void
	{
		switchMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/Level_Switch.csv");
        var mapTilePath:String = "assets/data/Misc.png";
        switchMap.loadMapFromCSV(mapData, mapTilePath, 64, 64);
		
		//add the switch
		for (point in switchMap.getTileCoords(29, false)){
			_switch = new Switch(this, point.x, point.y);
			_locks.add(_switch);
			
			//load the door(s)
			
			for (point in switchMap.getTileCoords(27, false)){
				var door = new Door(point.x, point.y, false, 27);
				_switch._doors.add(door);
				_doors.add(door);
			}
			for (i in switchMap.getTileInstances(27)){
				switchMap.setTileByIndex(i, -1, true);
			}
			
			for (point in switchMap.getTileCoords(28, false)){
				var door = new Door(point.x, point.y, false,28);
				_switch._doors.add(door);
				_doors.add(door);
			}
			//push the door onto the locks _doors
			for (i in switchMap.getTileInstances(28)){
				switchMap.setTileByIndex(i, -1, true);
			}
			
			for (point in switchMap.getTileCoords(5, false)){
				var door = new Door(point.x, point.y, true,5);
				_switch._doors.add(door);
				_doors.add(door);
			}
			//push the door onto the locks _doors
			for (i in switchMap.getTileInstances(5)){
				switchMap.setTileByIndex(i, -1, true);
			}
			
			//add weighted switch that opens all doors
			for (point in switchMap.getTileCoords(17, false)){
				_omni = new FlxObject(point.x, point.y-10,64,64);
			}	
		}
		//remove the lock sprites
		for (i in switchMap.getTileInstances(29)){
			switchMap.setTileByIndex(i, -1, true);
		}
		
		switchMap = null;
	}
	
	function loadObjects():Void
	{
		//add the death spots to the game
		for (point in Objects.getTileCoords(TILE_DEATH, false)){
			_dead.add(new FlxObject(point.x, point.y, 64, 64));
		}
		
		//add the crouch dialogue trigger
		for (point in Objects.getTileCoords(TILE_CRCH_TRG, false)){
			_crouchDialogueTrigger.add(new FlxObject(point.x, point.y, 64, 64));
		}
		
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
		
		//add introLynx
		for (point in Objects.getTileCoords(19, false)){
			ILynx = new IntroLynx(point.x, point.y);
		}
		for (i in Objects.getTileInstances(19)){
			Objects.setTileByIndex(i, -1, true);
		}
		
		//add ChaseLynx
		for (point in Objects.getTileCoords(21, false)){
			CLynx = new ChaseLynx(point.x, point.y);
		}
		for (i in Objects.getTileInstances(21)){
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
		
		super.update(elapsed);
		
		FlxG.overlap(_dead, _player1, dead);
		FlxG.overlap(_dead, _player2, dead);
		FlxG.overlap(_startTrigger, _player1, StrtTrig);
		FlxG.overlap(_startTrigger, _player2, StrtTrig);
		
		FlxG.overlap(_crouchDialogueTrigger, _player1, crouchTrig);
		FlxG.overlap(_crouchDialogueTrigger, _player2, crouchTrig);
		
		FlxG.overlap(_lockDialogueTrigger, _player1, lockTrig);
		FlxG.overlap(_lockDialogueTrigger, _player2, lockTrig);
		
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
		
		FlxG.collide(_boxes, _boxes);
		
		FlxG.collide(FtileMap, _boxes);
		FlxG.collide(FtileMap, CLynx);
		FlxG.collide(FtileMap, ILynx);
		
		//colide with doors
		FlxG.collide(FtileMap, _doors);
		FlxG.collide(_doors, _boxes);
		FlxG.collide(_doors, _player1);
		FlxG.collide(_doors, _player2);
		FlxG.collide(_doors, _deer);
		
		FlxG.overlap(_omni, _player1, openSwitchAll);
		
		_player1.beforeCollidePlayer();
		_player2.beforeCollidePlayer();
		
		FlxG.collide(_player1, _player2);
	}
	
	//trigger pressure plate to open up all sealed doors
	function openSwitchAll(thing:FlxObject, player:FlxObject):Void
	{
		_switch.unlockAll();
	}
	
	function StrtTrig(thing:FlxObject, player:FlxObject):Void
	{
		if (!SoundStore._stemB.playing) SoundStore._stemB.fadeIn(3);
		_startTrigger.kill();
	}
	
	function crouchTrig(thing:FlxObject, player:FlxObject):Void
	{
		_dialogue.showScript(Assets.getText("assets/text/mechanics/crouching.txt"), "crouching");
		_crouchDialogueTrigger.kill();
	}
	
	function lockTrig(thing:FlxObject, player:FlxObject):Void
	{
		_dialogue.showScript(Assets.getText("assets/text/mechanics/door.txt"), "door");
		_lockDialogueTrigger.kill();
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

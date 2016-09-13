package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlayState extends FlxState
{
	//two player objects, one controlled by WASD one by the arrow keys
	//look into Haxe inheritance 
	var _player1:Player1;
	var _player2:Player2;
	var _shadows:ShadowSystem;
	
	private var _level:FlxTilemap;
	
	override public function create():Void
	{
		
		bgColor = FlxColor.RED;
		
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
		
		_shadows = new ShadowSystem([]);
		
		//add the two players to the game
		_player1 = new Player1(10, 10, _shadows);
		add(_player1);
		_player2 = new Player2(20, 10);
		add(_player2);
		
		//setting gravity
		_player1.acceleration.y = _player2.acceleration.y = 600;
		
		add(_shadows);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		/*
			for handling groups and win conditions and collision
			FlxG.overlap(_coins, _player, getCoin);
			FlxG.collide(_level, _player);
			FlxG.overlap(_exit, _player, win);
		*/
		_shadows.beginLights();
		_shadows.addLight(700, 1600, 1000);
		_shadows.addLight(1200, 200, 130);
		
		super.update(elapsed);
		FlxG.collide(_level, _player1);
		FlxG.collide(_level, _player2);
		
	}
	
	override public function draw():Void
	{
		super.draw();
	}
}

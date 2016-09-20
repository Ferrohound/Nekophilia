package;

import flixel.FlxG;
import flixel.system.FlxSound;

class SoundStore
{
	public static var _stemA:FlxSound;
	public static var _stemB:FlxSound;
	public static var _stemC:FlxSound;
	public static var _stemD:FlxSound;
	public static var _stemE:FlxSound;
	public static var _stemF:FlxSound;
	public static var _stemG:FlxSound;

	public static var voiceAimee:FlxSound;
	public static var voiceOwen:FlxSound;
	
	public static var _AleftFoot:FlxSound;
	public static var _ArightFoot:FlxSound;
	public static var _OleftFoot:FlxSound;
	public static var _OrightFoot:FlxSound;

	public static var _boxDrag:FlxSound;
	
	public static var unlock:FlxSound;
	
	public static function loadAudio():Void
	{
		#if flash
		_stemA = FlxG.sound.load(AssetPaths.A_Base_Stem__mp3);
		_stemB = FlxG.sound.load(AssetPaths.B_Melody_Stem__mp3);
		_stemC = FlxG.sound.load(AssetPaths.C_MonsterApproach_Stem__mp3);
		_stemD = FlxG.sound.load(AssetPaths.D_Piano_Stem__mp3);
		_stemE = FlxG.sound.load(AssetPaths.E_Abrasive_Stem__mp3);
		_stemF = FlxG.sound.load(AssetPaths.F_Monster_Creeping_Stem__mp3);
		_stemG = FlxG.sound.load(AssetPaths.G_Soundscape_Stem__mp3);
		
		voiceAimee = FlxG.sound.load(AssetPaths.Aimee_Voice_Sample__mp3);
		voiceOwen  = FlxG.sound.load(AssetPaths.Owen_Voice_Sample__mp3);
		
		_AleftFoot  = FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_1__mp3);
		_ArightFoot = FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_2__mp3);
		_OleftFoot  = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_1__mp3);
		_OrightFoot = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_2__mp3);
		
		_boxDrag = FlxG.sound.load(AssetPaths.Spooky_Box_Drag__mp3);
		
		unlock = FlxG.sound.load(AssetPaths.Spooky_Door_Unlock__mp3);
		#else
		_stemA = FlxG.sound.load(AssetPaths.A_Base_Stem__ogg);
		_stemB = FlxG.sound.load(AssetPaths.B_Melody_Stem__ogg);
		_stemC = FlxG.sound.load(AssetPaths.C_MonsterApproach_Stem__ogg);
		_stemD = FlxG.sound.load(AssetPaths.D_Piano_Stem__ogg);
		_stemE = FlxG.sound.load(AssetPaths.E_Abrasive_Stem__ogg);
		_stemF = FlxG.sound.load(AssetPaths.F_Monster_Creeping_Stem__ogg);
		_stemG = FlxG.sound.load(AssetPaths.G_Soundscape_Stem__ogg);
		
		voiceAimee = FlxG.sound.load(AssetPaths.Aimee_Voice_Sample__ogg);
		voiceOwen  = FlxG.sound.load(AssetPaths.Owen_Voice_Sample__ogg);
		
		_AleftFoot  = FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_1__ogg);
		_ArightFoot = FlxG.sound.load(AssetPaths.Spooky_Aimee_Footstep_2__ogg);
		_OleftFoot  = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_1__ogg);
		_OrightFoot = FlxG.sound.load(AssetPaths.Spooky_Owen_Footstep_2__ogg);
		
		_boxDrag = FlxG.sound.load(AssetPaths.Spooky_Box_Drag__ogg);
		
		unlock = FlxG.sound.load(AssetPaths.Spooky_Door_Unlock__ogg);
		#end
	}
}

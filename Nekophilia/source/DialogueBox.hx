package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

class DialogueBox extends FlxSpriteGroup
{
	public static inline var ST_CHAR_DELAY = 0.03;
	
	private var _voices    : Map<String, FlxSound>;
	private var _currVoice : FlxSound;
	
	public var vPadding  : Int;
	
	private var _textBox : FlxText;
	private var _nameBox : FlxText;
	private var _bgBox   : FlxSprite;
	
	public var _script(default, null): String;
	public var _tag   (default, null): String;
	private var _currChar : Int;
	private var _timer    : Float;
	private var _delay    : Float;
	
	public var typing(default, null) = false;
	public var canSkip = true;
	
	public var onExit    : Bool->String->DialogueBox->Bool;
	public var callbacks : Array<Void -> Void>;
	
	override public function new(voices:Map<String,FlxSound>, width=250, height=75, vPadding=10) 
	{
		super();
		this.width = width;
		this.height = height;
		this.vPadding = vPadding;
		
		_voices = voices;
		
		this.scrollFactor.set(0, 0);
		
		_bgBox = new FlxSprite();
		_bgBox.makeGraphic(width, height, 0xFFF9A060);
		FlxSpriteUtil.drawRect(_bgBox, 5, 5, width - 10, height - 10, 0xFFFDD6B9);
		add(_bgBox);
		
		_nameBox = new FlxText(5, -17, 0, "", 15);
		_nameBox.wordWrap = false;
		_nameBox.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(_nameBox);
		
		_textBox = new FlxText(5, 5, width - 10, "", 10);
		_textBox.wordWrap = false;
		_textBox.color = FlxColor.BLACK;
		add(_textBox);
		
		updatePosition();
		
		this.pixelPerfectRender = true;
		this.kill();
	}
	
	override public function update(elapsed:Float): Void
	{
		_timer += elapsed;
		
		while (typing && _timer >= _delay && _currChar < _script.length) {
			_timer -= _delay;
			_delay = ST_CHAR_DELAY;
			
			var char = _script.charAt(_currChar++);
			if (char == '@') {
				var next = _script.charAt(_currChar++);
				
				switch(next) {
				case '\\':
					typeString('\n');
				case ':':
					var eol = nextIndexOf(_script, '\n', _currChar);
					setName(_script.substring(_currChar, eol));
					_currChar = eol + 1;
					_delay = 0;
				case 'x':
					_textBox.text = "";
					_delay = 0;
				case '>':
					_timer = Math.POSITIVE_INFINITY;
					_delay = 0;
				case '<':
					_timer = 0;
					_delay = 0;
				case '':
					exitScript();
				default:
					var i = Std.parseInt(next);
					if (i == null) {
						typeString(next);
					} else {
						_delay = 0;
						if (callbacks != null && i < callbacks.length) {
							callbacks[i]();
						}
					}
				}
			} else if (char == '\n' && _script.charAt(_currChar) == '\n') {
				typing = false;
				++_currChar;
			} else {
				typeString(char);
				if (_currChar >= _script.length) {
					typing = false;
				}
			}
		}
		if (FlxG.keys.anyJustPressed([SPACE])) {
			if (typing) {
				if (canSkip) _timer = Math.POSITIVE_INFINITY;
			} else if (_currChar >= _script.length) {
				exitScript();
			} else {
				_textBox.text = "";
				typing = true;
				_delay = _timer = 0;
			}
		}
	}
	
	public function typeString(char:String)
	{
		_textBox.text += char;
		if (_currVoice != null) {
			_currVoice.play();
		}
	}
	
	public function setName(name:String) : String
	{
		_nameBox.text = name;
		_currVoice = _voices[name];
		return name;
	}
	
	public function getName() : String
	{
		return _nameBox.text;
	}
	
	/**
	 * Begin reading a dialogue script. Will cancel any other running scripts.
	 * 
	 * @param	script
	 * The script itself. By default, a script that closes itself
	 * immediately.
	 * 
	 * SYNTAX:
	 * 
	 * Most text prints normally. Any line breaks must be present
	 * in the script, as they will not be added automatically,
	 * and lines without them will likely be cut off. With default
	 * settings, the text box is about 35 characters wide and 5
	 * lines high.
	 * 
	 * SPECIAL CASES:
	 * - Empty line :
	 * -	The player must press space to progress, at which point the text
	 * -	box will be cleared.
	 * - `@@` :
	 * -	Becomes a single, non-special @ symbol.
	 * - `@:` :
	 * -	The rest of the current line is inserted into the name box, and
	 * -	reading continues as normal at the beginning of the next line.
	 * -	If there is nothing else on this line, this has the effect of
	 * -	clearing the name box.
	 * - `@\` :
	 * -	Inserts a line break. Can be used to have an empty line without
	 * -	activating the special case.
	 * - `@x` :
	 * -	Clears the screen. Useful for having one line go straight into
	 * -	another.
	 * - `@>` :
	 * -	Immediately prints all dialogue left in paragraph, as if skip
	 * -	had been pressed.
	 * - `@<` :
	 * -	Stops skip here, leaving text to continue as normal.
	 * - `@0` - `@9` :
	 * -	Executes the corresponding callback. See `callbacks`. If no such
	 * -	callback exists, the characters are ignored completely.
	 * - `@` at the exact end of the file :
	 * -	The script ends immediately, without waiting for the player to
	 * -	press space.
	 * - `@` in any other context :
	 * -	The @ is ignored, and the following character is displayed as
	 * -	normal text.
	 * -
	 * @param	tag -
	 * A string which identifies the currently running script.
	 * @param	onExit -
	 * A callback which will be executed when the script exits.
	 * Arguments:
	 * - finished:Bool
	 * -	True if the script completed naturally, false if it was overriden by
	 * -	another script.
	 * - overrideTag:String
	 * -	The tag of the overriding script, which will be null if the script
	 * -	exited naturally, or no key was provided.
	 * - dialogue:DialogueBox
	 * -	This dialogue box.
	 * Returns:Bool
	 * -	Whether or not an overriding script should be allowed to override.
	 * -	If true the override proceeds as normal, if false the override fails.
	 * -	No effect if script finishes naturally.
	 * @param	callbacks -
	 * A list of functions which can be executed by the script at arbitrary
	 * points using the format `@0` - `@9`. More than ten functions can
	 * be provided, but there is currently no way for the script to access
	 * them.
	 * @return
	 * Whether script was successfully begun. False if the script was prevented
	 * from running by an already active script, true otherwise.
	 */
	public function showScript(
		script = "@",
		?tag : String,
		?onExit : Bool->String->DialogueBox->Bool,
		?callbacks : Array<Void->Void>
	) : Bool
	{
		if (this.onExit == null || this.onExit(false, tag, this)) {
			_script = script.split('\r\n').join('\n');
			_tag = tag;
			_textBox.text = _nameBox.text = "";
			_timer = _delay = _currChar = 0;
			_currVoice = null;
			
			this.onExit = onExit;
			this.callbacks = callbacks;
			
			typing = true;
			this.revive();
			
			return true;
		} else {
			return false;
		}
	}
	
	public inline function updatePosition(?x:Float, ?y:Float) : Void
	{
		this.x = (x != null) ? x : FlxG.width  / 2 - this.width / 2;
		this.y = (y != null) ? y : FlxG.height - this.height - vPadding;
	}
	
	private inline function exitScript() : Void
	{
		this.kill();
		typing = false;
		if (onExit != null) onExit(true, null, this);
		_script = _tag = null;
		_currVoice = null;
		onExit = null;
	}
	
	public static function nextIndexOf(str:String, char:String, start=0) : Int
	{
		var next : String;
		while (char != (next = str.charAt(start))) {
			if (next == '') return -1;
			++start;
		}
		return start;
	}
	
}
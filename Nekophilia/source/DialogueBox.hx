package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

class DialogueBox extends FlxSpriteGroup
{
	public static inline var ST_CHAR_DELAY = 0.03;
	
	public var vPadding  : Int;
	
	private var _textBox : FlxText;
	private var _nameBox : FlxText;
	private var _bgBox   : FlxSprite;
	
	private var _script   : String;
	private var _currChar : Int;
	private var _currLine : Int;
	private var _timer    : Float;
	private var _delay    : Float;
	
	public var typing(default, null) = false;
	public var canSkip = true;
	
	public var onExit    :       Void -> Void;
	public var callbacks : Array<Void -> Void>;
	
	override public function new(width=500, height=150, vPadding=20) 
	{
		super();
		this.width = width;
		this.height = height;
		this.vPadding = vPadding;
		
		this.scrollFactor.set(0, 0);
		
		_bgBox = new FlxSprite();
		_bgBox.makeGraphic(width, height, 0xFFF9A060);
		FlxSpriteUtil.drawRect(_bgBox, 5, 5, width - 10, height - 10, 0xFFFDD6B9);
		add(_bgBox);
		
		_nameBox = new FlxText(5, -40, 0, "", 30);
		_nameBox.wordWrap = false;
		_nameBox.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
		add(_nameBox);
		
		_textBox = new FlxText(10, 10, width - 20, "", 20);
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
					_textBox.text += '\n';
				case ':':
					var eol = nextIndexOf(_script, '\n', _currChar);
					_nameBox.text = _script.substring(_currChar, eol);
					_currChar = eol + 1;
					_delay = 0;
				case '':
					this.kill();
					typing = false;
					if (onExit != null) onExit();
				default:
					var i = Std.parseInt(next);
					if (i == null) {
						_textBox.text += next;
					} else {
						_delay = 0;
						if (callbacks != null && i < callbacks.length) {
							callbacks[i]();
						}
					}
				}
			} else if (char == '\n' && (_currChar >= _script.length || _script.charAt(_currChar) == '\n')) {
				typing = false;
				++_currChar;
			} else {
				_textBox.text += char;
			}
		}
		if (FlxG.keys.anyJustPressed([SPACE])) {
			if (typing) {
				if (canSkip) _timer = Math.POSITIVE_INFINITY;
			} else if (_currChar >= _script.length) {
				this.kill();
				typing = false;
				if (onExit != null) onExit();
			} else {
				_textBox.text = "";
				typing = true;
				_delay = _timer = 0;
			}
		}
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
	 * @param	onExit -
	 * A callback which will be executed when the script exits. It will not
	 * be called if the script is cancelled by beginning another script.
	 * @param	callbacks -
	 * A list of functions which can be executed by the script at arbitrary
	 * points using the format `@0` - `@9`. More than ten functions can
	 * be provided, but there is currently no way for the script to access
	 * them.
	 */
	public function showScript(script="@", ?onExit:Void->Void, ?callbacks:Array<Void->Void>)
	{
		_script = script.split('\r\n').join('\n');
		_textBox.text = _nameBox.text = "";
		_timer = _delay = _currChar = 0;
		
		this.onExit = onExit;
		this.callbacks = callbacks;
		
		typing = true;
		this.revive();
	}
	
	public inline function updatePosition(?x:Float, ?y:Float) : Void
	{
		this.x = (x != null) ? x : FlxG.width  / 2 - this.width / 2;
		this.y = (y != null) ? y : FlxG.height - this.height - vPadding;
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
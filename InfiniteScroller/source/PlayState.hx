package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.display.FPS;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var sprites:Array<FlxSprite>;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		FlxG.debugger.visible = true;
		sprites = new Array<FlxSprite>();
		for(i in 0...200) {
			var s = new FlxSprite();
			s.makeGraphic(50, 50, FlxColor.BLUE);
			s.x = 100 * i;
			s.y = 200;
			sprites.push(s);
			add(s);
		}
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		for (i in 0...200) {
			var s:FlxSprite = sprites[i];
			s.x -= 300 * elapsed;
		}
	}
}

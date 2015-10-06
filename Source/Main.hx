package;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Graphics;
import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.events.Event;
import openfl.events.GameInputEvent;
import openfl.ui.GameInput;
import openfl.Lib;
import openfl.Assets;
import lime.ui.Joystick;
import lime.ui.Gamepad;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var bitmap = new Bitmap (Assets.getBitmapData ("assets/openfl.png"));
		trace(bitmap);
		trace(bitmap.width);
		trace(bitmap.height);
		addChild (bitmap);
		
		bitmap.x = (stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (stage.stageHeight - bitmap.height) / 2;

		/*this.graphics.lineStyle(10, 0xFF0000, 1, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 10);
		this.graphics.beginFill(0x00FF00, 1);
		this.graphics.drawRect(0, 0, 500, 500);
		this.graphics.endFill();*/

		var input = new GameInput ();
		input.addEventListener (GameInputEvent.DEVICE_ADDED, function (e:GameInputEvent) {

			trace ("Connected game input: " + e.device);

			for (i in 0...e.device.numControls) {

				var control = e.device.getControlAt (i);
				trace("Control: " + control.id);
				control.addEventListener (Event.CHANGE, function (e) trace ("Control " + control.id + ": " + control.value));

			}

		});

		lime.ui.Gamepad.onConnect.add (function (gamepad) {
    
    		gamepad.onButtonDown.add (function (button) {
        
        		trace ("Pressed " + button);
        
    		});
    
		});

		lime.ui.Joystick.onConnect.add (function (joystick) {
    
		    joystick.onButtonDown.add (function (button) { trace ("Button Down: " + button); });
    
		});

    }



}

import luxe.GameConfig;
import luxe.Input;
import phoenix.Texture;
import luxe.Vector;

class Main extends luxe.Game {

	private var addingBunnies:Bool;
	private var bunnies:Array<Bunny>;
	private var fps:FPS;
	private var gravity:Float;
	private var minX:Int;
	private var minY:Int;
	private var maxX:Int;
	private var maxY:Int;
	private var image:Texture;

    override function config(config:GameConfig) {

        config.window.title = 'BummyMarkLuxe';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

		config.preload.textures.push({ id:'assets/wabbit_alpha.png' });

        return config;

    } //config

    override function ready() {
		bunnies = new Array ();

		minX = 0;
		maxX = Luxe.screen.w;
		minY = 0;
		maxY = Luxe.screen.h;
		gravity = 0.5;

		image = Luxe.resources.texture('assets/wabbit_alpha.png');


		fps = new FPS ();
		//addChild (fps);

		for (i in 0...100) {

			addBunny ();

		}

    } //ready

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

        if (event.keycode == Key.space) {
            for (i in 0...100) {
                addBunny ();
            }
        }

    } //onkeyup

    override function update(delta:Float) {
		for (bunny in bunnies) {

			bunny.pos.x += bunny.speedX;
			bunny.pos.y += bunny.speedY;
			bunny.speedY += gravity;

			if (bunny.pos.x > maxX) {

				bunny.speedX *= -1;
				bunny.pos.x = maxX;

			} else if (bunny.pos.x < minX) {

				bunny.speedX *= -1;
				bunny.pos.x = minX;

			}

			if (bunny.pos.y > maxY) {

				bunny.speedY *= -0.8;
				bunny.pos.y = maxY;

				if (Math.random () > 0.5) {

					bunny.speedY -= 3 + Math.random () * 4;

				}

			} else if (bunny.pos.y < minY) {

				bunny.speedY = 0;
				bunny.pos.y = minY;

			}

		}

		if (addingBunnies) {

			for (i in 0...100) {

				addBunny ();

			}

		}

    } //update

    private function addBunny ():Void {

		var bunny = new Bunny ({
			name: 'bunny' + bunnies.length,
			texture: image,
			pos: new Vector(0, 0),
		});
		bunny.speedX = Math.random () * 5;
		bunny.speedY = (Math.random () * 5) - 2.5;
		bunnies.push (bunny);
	}

	public override function onmousedown(event:MouseEvent) {
		addingBunnies = true;
	}

	public override function onmouseup(event:MouseEvent) {
		addingBunnies = false;
		trace (bunnies.length + " bunnies");
	}


} //Main

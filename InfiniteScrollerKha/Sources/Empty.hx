package;

import kha.Game;
import kha.Image;
import kha.Framebuffer;
import kha.Configuration;
import kha.LoadingScreen;
import kha.Loader;
import kha.math.FastMatrix3;
import kha.Scaler;
import kha.Sys;
import kha.Scheduler;
import kha2d.Sprite;
import kha2d.Scene;

import cata2d.importers.tiled.TiledMap;

class Empty extends Game {

	var backbuffer: Image;
	var sprites:Array<Sprite>;
	var totalFrames:Int;
	var elapsedTime:Float;
	var fps:Int;
	var previousTime:Float;		
	
	public function new() {
		super("Empty", false);
	}

	override public function init(): Void {
		backbuffer = Image.createRenderTarget(640, 480);
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("level1", initLevel);
	}

	private function initLevel(): Void {
		Configuration.setScreen(this);
		
		previousTime = 0;
		elapsedTime = 0;
		totalFrames = 0;
		fps = 0;

		sprites = new Array<Sprite>();
		for(i in 0...200) {
			var s = new Sprite(Loader.the.getImage("player"), 16, 16, 0);
			s.x = 100 * i;
			s.y = 200;
			sprites.push(s);
			Scene.the.addHero(s);
		}
	}

	override public function update() : Void {
		var currentTime:Float = Scheduler.time();
		var deltaTime:Float = (currentTime - previousTime);
		previousTime = currentTime;
		
        elapsedTime += deltaTime;
        totalFrames++;		
		if (elapsedTime >= 1.0) {
			fps = totalFrames;
			totalFrames = 0;
			elapsedTime = 0;			
		}		

		for (i in 0...200) {
			var s:Sprite = sprites[i];
			s.x -= 300 * deltaTime;
		}
		Scene.the.update();
		trace(fps);
	}

	override public function render(frame: Framebuffer): Void {
		var g = backbuffer.g2;
		g.begin();
		g.transformation = FastMatrix3.identity();
		//g.drawImage(Loader.the.getImage("bg2"), 0, 0);
		Scene.the.render(g);
		g.end();
		
		startRender(frame);
		Scaler.scale(backbuffer, frame, Sys.screenRotation);
		endRender(frame);
	}
}

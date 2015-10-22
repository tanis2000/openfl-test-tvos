
import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {

    var sprites:Array<Sprite>;
    var hxt:hxtelemetry.HxTelemetry;
    
    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {
        var cfg = new hxtelemetry.HxTelemetry.Config();
        cfg.allocations = true;
        cfg.app_name = "InfiniteScrollerLuxe";
        cfg.host = "172.16.69.110";
        hxt = new hxtelemetry.HxTelemetry(cfg);

        sprites = new Array<Sprite>();
        for(i in 0...200) {
            var s = new Sprite({size:new Vector(50, 50), color: new Color(0, 0, 1, 1)});
            s.pos.x = 100 * i;
            s.pos.y = 200;
            sprites.push(s);
        }

    } //ready

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {
        for (i in 0...200) {
            var s:Sprite = sprites[i];
            s.pos.x -= 300 * dt;
        }
        hxt.advance_frame();
    } //update


} //Main

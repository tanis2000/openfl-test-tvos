package cata2d.tilemaps;

import kha.Color;
import kha.graphics2.Graphics;
import kha.math.Vector2;
import kha.math.Vector2i;
import kha.Rectangle;
import kha.Image;

@:expose
class Tilemap {
	var tilesets: Map<String, Tileset>;
	var map: Array<Array<Int>>;
	// the width of the map in tiles
	var levelWidth: Int;
	// the height of the map in tiles
	var levelHeight: Int;
	// the width of a tile
	var tileWidth:Int;
	// the height of a tile
	var tileHeight:Int;
	// the origin of the map in world space
	var pos:Vector2;

	var collisionRectCache: Rectangle;
	
	public function new(mapX:Int, mapY:Int, width: Int, height: Int, tw:Int, th:Int) {
		pos = new Vector2(mapX, mapY);
		levelWidth = width;
		levelHeight = height;
		tileWidth = tw;
		tileHeight = th;
		collisionRectCache = new Rectangle(0, 0, tw, th);
        tilesets = new Map<String,Tileset>();
	}
	
	/** Add a tileset with the given options */
    public function addTileset( name:String, texture:Image, tw:Int, th:Int ) {

        var tileset = new Tileset( name, texture, tw, th );

           tilesets.set( tileset.name, tileset );

        return tileset;

    } //add_tileset

    /** Add a layer with the given options */
    public function addLayer( options:TileLayerOptions ) {

        def(options.map, this);

        var new_layer = new TileLayer( options );

                //store in the named layer map
            layers.set( new_layer.name, new_layer );
                //store in the ordered list as well
            layers_ordered.push( new_layer );
                //and sort the list
            sort_layers();

        return new_layer;

    } //add_layer


	public function index(xpos: Float, ypos: Float): Vector2i {
		var xtile: Int = Std.int(xpos / tileset.TILE_WIDTH);
		var ytile: Int = Std.int(ypos / tileset.TILE_HEIGHT);
		return new Vector2i(xtile, ytile);
	}
	
	public function get(x: Int, y: Int): Int {
		return map[x][y];
	}
	
	public function set(x: Int, y: Int, value: Int) {
		map[x][y] = value;
	}
	
	private static function mod(a: Int, b: Int): Int {
		var r = a % b;
		return r < 0 ? r + b : r;
	}
	
	public function render(g: Graphics, xleft: Int, ytop: Int, width: Int, height: Int): Void {
		g.color = Color.White;
		if (repeat) {
			var xstart: Int = Std.int(xleft / tileset.TILE_WIDTH) - 1;
			var xend: Int = Std.int((xleft + width) / tileset.TILE_WIDTH + 1);
			var ystart: Int = Std.int(ytop / tileset.TILE_HEIGHT) - 1;
			var yend: Int = Std.int((ytop + height) / tileset.TILE_HEIGHT + 2);
			for (x in xstart...xend) for (y in ystart...yend) {
				tileset.render(g, map[mod(x, levelWidth)][mod(y, levelHeight)], x * tileset.TILE_WIDTH, y * tileset.TILE_HEIGHT);
			}			
		}
		else {
			var xstart: Int = Std.int(Math.max(xleft / tileset.TILE_WIDTH - 1, 0));
			var xend: Int = Std.int(Math.min((xleft + width) / tileset.TILE_WIDTH + 1, levelWidth));
			var ystart: Int = Std.int(Math.max(ytop / tileset.TILE_HEIGHT - 1, 0));
			var yend: Int = Std.int(Math.min((ytop + height) / tileset.TILE_HEIGHT + 2, levelHeight));
			for (x in xstart...xend) for (y in ystart...yend) {
				tileset.render(g, map[x][y], x * tileset.TILE_WIDTH, y * tileset.TILE_HEIGHT);
			}
		}
	}
	
	public function collidesPoint(point: Vector2): Bool {
		var xtile: Int = Std.int(point.x / tileset.TILE_WIDTH);
		var ytile: Int = Std.int(point.y / tileset.TILE_HEIGHT);
		return tileset.tile(map[xtile][ytile]).collides;
	}
	
	public function collides(sprite: Sprite): Bool {
		var rect = sprite.collisionRect();
		if (rect.x <= 0 || rect.y <= 0 || rect.x + rect.width >= getWidth() * tileset.TILE_WIDTH || rect.y + rect.height >= getHeight() * tileset.TILE_HEIGHT) return true;
		var delta = 0.001;
		var xtilestart : Int = Std.int((rect.x + delta) / tileset.TILE_WIDTH);
		var xtileend : Int = Std.int((rect.x + rect.width - delta) / tileset.TILE_WIDTH);
		var ytilestart : Int = Std.int((rect.y + delta) / tileset.TILE_HEIGHT);
		var ytileend : Int = Std.int((rect.y + rect.height - delta) / tileset.TILE_HEIGHT);
		for (ytile in ytilestart...ytileend + 1) {
			for (xtile in xtilestart...xtileend + 1) {
				collisionRectCache.x = rect.x - xtile * tileset.TILE_WIDTH;
				collisionRectCache.y = rect.y - ytile * tileset.TILE_HEIGHT;
				collisionRectCache.width = rect.width;
				collisionRectCache.height = rect.height;
				if (xtile >= 0 && ytile >= 0 && xtile < map.length && ytile < map[xtile].length && tileset.tile(map[xtile][ytile]) != null)
					if (tileset.tile(map[xtile][ytile]).collision(collisionRectCache)) return true;
			}
		}
		return false;
	}
	
	function collidesupdown(x1: Int, x2: Int, y: Int, rect: Rectangle): Bool {
		if (y < 0 || y / tileset.TILE_HEIGHT >= levelHeight) return false;
		var xtilestart: Int = Std.int(x1 / tileset.TILE_WIDTH);
		var xtileend: Int = Std.int(x2 / tileset.TILE_WIDTH);
		var ytile: Int = Std.int(y / tileset.TILE_HEIGHT);
		for (xtile in xtilestart...xtileend + 1) {
			collisionRectCache.x = rect.x - xtile * tileset.TILE_WIDTH;
			collisionRectCache.y = rect.y - ytile * tileset.TILE_HEIGHT;
			collisionRectCache.width = rect.width;
			collisionRectCache.height = rect.height;
			if (tileset.tile(map[xtile][ytile]).collision(collisionRectCache)) return true;
		}
		return false;
	}
	
	function collidesrightleft(x: Int, y1: Int, y2: Int, rect: Rectangle): Bool {
		if (x < 0 || x / tileset.TILE_WIDTH >= levelWidth) return true;
		var ytilestart: Int = Std.int(y1 / tileset.TILE_HEIGHT);
		var ytileend: Int = Std.int(y2 / tileset.TILE_HEIGHT);
		var xtile: Int = Std.int(x / tileset.TILE_WIDTH);
		for (ytile in ytilestart...ytileend + 1) {
			if (ytile < 0 || ytile >= levelHeight) continue;
			collisionRectCache.x = rect.x - xtile * tileset.TILE_WIDTH;
			collisionRectCache.y = rect.y - ytile * tileset.TILE_HEIGHT;
			collisionRectCache.width = rect.width;
			collisionRectCache.height = rect.height;
			if (tileset.tile(map[xtile][ytile]).collision(collisionRectCache)) return true;
		}
		return false;
	}
	
	/*public function collides(x : Int, y : Int) : Bool {
		if (x < 0 || x / tileset.TILE_WIDTH >= levelWidth) return true;
		if (y < 0 || y / tileset.TILE_HEIGHT >= levelHeight) return false;
		
		var value : Int = map[Std.int(x / tileset.TILE_WIDTH)][Std.int(y / tileset.TILE_HEIGHT)];
		
		return tileset.tile(value).collides;
	}*/
	
	private static function round(value: Float): Int {
		return Math.round(value);
	}
	
	public function collideright(sprite: Sprite): Bool {
		var rect: Rectangle = sprite.collisionRect();
		var collided: Bool = false;
		while (collidesrightleft(Std.int(rect.x + rect.width), round(rect.y + 1), round(rect.y + rect.height - 1), rect)) {
			--sprite.x; // = Math.floor((rect.x + rect.width) / tileset.TILE_WIDTH) * tileset.TILE_WIDTH - rect.width;
			collided = true;
			rect = sprite.collisionRect();
		}
		return collided;
	}
	
	public function collideleft(sprite: Sprite): Bool {
		var rect: Rectangle = sprite.collisionRect();
		var collided: Bool = false;
		while (collidesrightleft(Std.int(rect.x), round(rect.y + 1), round(rect.y + rect.height - 1), rect)) {
			++sprite.x; // = (Math.floor(rect.x / tileset.TILE_WIDTH) + 1) * tileset.TILE_WIDTH;
			collided = true;
			rect = sprite.collisionRect();
		}
		return collided;
	}
	
	public function collidedown(sprite: Sprite): Bool {
		var rect: Rectangle = sprite.collisionRect();
		var collided: Bool = false;
		while (collidesupdown(round(rect.x + 1), round(rect.x + rect.width - 1), Std.int(rect.y + rect.height), rect)) {
			--sprite.y; // = Math.floor((rect.y + rect.height) / tileset.TILE_HEIGHT) * tileset.TILE_HEIGHT - rect.height;
			collided = true;
			rect = sprite.collisionRect();
		}
		return collided;
	}
	
	public function collideup(sprite: Sprite): Bool {
		var rect: Rectangle = sprite.collisionRect();
		var collided: Bool = false;
		while (collidesupdown(round(rect.x + 1), round(rect.x + rect.width - 1), Std.int(rect.y), rect)) {
			++sprite.y; // = ((Math.floor(rect.y / tileset.TILE_HEIGHT) + 1) * tileset.TILE_HEIGHT);
			collided = true;
			rect = sprite.collisionRect();
		}
		return collided;
	}
	
	public function getWidth(): Int {
		return levelWidth;
	}
	
	public function getHeight(): Int {
		return levelHeight;
	}
	
	public function getTileset(): Tileset {
		return tileset;
	}
}

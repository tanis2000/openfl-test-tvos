package cata2d.tilemaps;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Loader;

class Tileset {
	public var texture:Image;
	public var tileWidth : Int = 0;
	public var tileHeight : Int = 0;
	public var name:String;
	public var firstId:Int = 1;
	public var margin:Int =  0;
	public var spacing:Int = 0;

	public function new(name:String, texture:Image, tw:Int, th:Int) {
		this.name = name;
		this.texture = texture;
		this.tileWidth = tw;
		this.tileHeight = th;
	}
	
	public function render(g: Graphics, tile: Int, x: Int, y: Int): Void {
	}
	
}

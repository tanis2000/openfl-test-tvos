package cata2d.importers.tiled;

import cata2d.importers.tiled.TiledMapData;
import cata2d.importers.tiled.TiledUtil.valid_element;

import kha.Image;

class TiledTileset {

    public var name : String = '';
    public var texture_name : String = '';

    public var first_id : Int = 1;
    public var tile_width : Int = 0;
    public var tile_height : Int = 0;
    public var margin : Int = 0;
    public var spacing : Int = 0;

    public var properties : Map<String,String>;
    public var property_tiles:Map<Int, TiledPropertyTile>;

    public function new(  ) {

        properties = new Map();
        property_tiles = new Map();

    } //new


    public function from_xml( xml:Xml ) {

        var root = xml;

        name = root.get("name");
        tile_width = Std.parseInt(root.get("tilewidth"));
        tile_height = Std.parseInt(root.get("tileheight"));
        spacing = Std.parseInt(root.get("spacing"));
        margin = Std.parseInt(root.get("margin"));

        for(child in root.elements()) {
            if(valid_element(child)) {

                switch(child.nodeName) {

                    case "properties" : {
                        for( property in child ) {
                            if( valid_element(property) ) {
                                properties.set( property.get("name"), property.get("value") );
                            }
                        } //for each property node
                    } //properties

                    case "image" : {
                        // var width = Std.parseInt(child.get("width"));
                        // var height = Std.parseInt(child.get("height"));
                        texture_name = child.get("source");
                    } //image

                    case "tile" : {
                        var _tile_id:Int = Std.parseInt(child.get("id"));
                        var _tile_props:Map<String, String> = new Map<String, String>();

                            for (element in child) {
                                if(valid_element(element)) {
                                    if (element.nodeName == "properties") {

                                        for (property in element) {

                                            if (!valid_element(property)) {
                                                continue;
                                            } //?not valid

                                            _tile_props.set(property.get("name"), property.get("value"));

                                        } //for each property element

                                    } //if it's a properties node
                                } //if valid
                            } //for each tile node

                        property_tiles.set(_tile_id, new TiledPropertyTile(_tile_id, _tile_props));
                    } //tile

                } //switch child nodename

            } //is valid node
        } //for each child

    } //from_xml


    public function from_json( json:Dynamic ) {

        name = Reflect.field(json, "name");
        tile_width = cast Reflect.field(json, "tilewidth");
        tile_height = cast Reflect.field(json, "tileheight");
        spacing = cast Reflect.field(json, "spacing");
        margin = cast Reflect.field(json, "margin");

        var fields = Reflect.fields(json);
        for(nodename in fields) {

            var child = Reflect.field(json, nodename);
                switch(nodename) {

                    case "properties" : {
                        var child_fields = Reflect.fields(child);
                        for (property_name in child_fields) {
                            properties.set(property_name, Reflect.field(child, property_name));
                        } //for each property
                    } //properties

                    case "image" : {
                        // var width = cast Reflect.field(child, "width");
                        // var height = cast Reflect.field(child, "height");
                        texture_name = child;
                    } //image

                    case "tile" : {
                        var _tile_id:Int = cast Reflect.field(child, "id");
                        var _tile_props:Map<String, String> = new Map<String, String>();

                            var tile_fields = Reflect.fields(child);
                            for(tile_node in tile_fields) {
                                if(tile_node == "properties") {
                                    var tile_item = Reflect.field(child, tile_node);
                                    var child_fields = Reflect.fields(tile_item);
                                    for (property_name in child_fields) {
                                        properties.set(property_name, Reflect.field(tile_item, property_name));
                                    } //for each property
                                } //if it's a properties node
                            } //for each tile node

                        property_tiles.set(_tile_id, new TiledPropertyTile(_tile_id, _tile_props));

                    } //tile

                } //switch child nodename

        } //for each child

    } //from_xml
} //TiledTileset

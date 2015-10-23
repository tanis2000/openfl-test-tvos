package cata2d.importers.tiled;

import cata2d.importers.tiled.TiledMapData;
import cata2d.importers.tiled.TiledUtil.valid_element;

import kha.math.Vector2;

enum TiledObjectType {
    polyline;
    polygon;
    rectangle;
    ellipse;
} //TiledObjectType

class TiledPolyObject {
    public var origin:Vector2;
    public var points:Array<Vector2>;
    public function new(_origin:Vector2, _points:Array<Vector2>) {
        origin = _origin;
        points = _points;
    }
} //TiledPolyObject

class TiledObject {

        /** The group that this TiledObject is from */
    public var group : TiledObjectGroup;
        /** Unique ID of the object. Each object that is placed on a map gets a unique id.
            Even if an object was deleted, no object gets the same ID. */
    public var id:Int;
        /** The name of this object */
    public var name:String;
        /** The type of this object */
    public var type:String;
        /** The x coordinate of this object (in pixels!) */
    public var pos:Vector2;
        /** The width of this object in pixels */
    public var width:Int;
        /** The width of this object in pixels */
    public var height:Int;
        /** The rotation of the object in degrees clockwise */
    public var rotation:Float;
        /** A reference to a tile (optional). */
    public var gid:Int;
        /** if it's visible */
    public var visible:Bool = true;
        /** The object that represents a poly-like object (line/polygon) */
    public var polyobject:TiledPolyObject;
        /** The type of object this object represents */
    public var object_type : TiledObjectType;
        /** Contains all properties from this object */
    public var properties:Map<String, String>;

    public function new( _group:TiledObjectGroup ) {
        group = _group;
        properties = new Map();
        pos = new Vector2();
    }

    function polyobject_from_xml( xml:Xml ) {

        var points:Array<Vector2> = new Array<Vector2>();
        var pointsAsString:String = xml.get("points");
        var pointsAsStringArray:Array<String> = pointsAsString.split(" ");

        for(point in pointsAsStringArray) {
            var coords:Array<String> = point.split(",");
            points.push(new Vector2(Std.parseInt(coords[0]), Std.parseInt(coords[1])));
        }

        var c:Vector2 = new Vector2(pos.x, pos.y);
        return new TiledPolyObject( c, points );

    } //polyobject_from_xml

    function polyobject_from_json( json:Dynamic ) {

            //json gives us the object as an array of objects with x,y properties

        var points:Array<Vector2> = new Array<Vector2>();
        var point_list : Array<Dynamic> = cast json;
        for(point in point_list) {
            var _x = cast Reflect.field(point,"x");
            var _y = cast Reflect.field(point,"y");
            points.push(new Vector2(_x,_y));
        }

        var c:Vector2 = new Vector2(pos.x, pos.y);
        return new TiledPolyObject( c, points );

    } //polyobject_from_json

    public function from_xml( xml:Xml ) {

        gid = xml.get("gid") != null ? Std.parseInt(xml.get("gid")) : 0;
        id = Std.parseInt(xml.get("id"));
        name = xml.get("name");
        type = xml.get("type");
        visible = xml.get("visible") != "0";
        pos.x = Std.parseInt(xml.get("x"));
        pos.y = Std.parseInt(xml.get("y"));
        width = Std.parseInt(xml.get("width"));
        height = Std.parseInt(xml.get("height"));
        rotation = xml.get("rotation") != null ? Std.parseFloat(xml.get("rotation")) : 0;

        //default to rectangle
        object_type = TiledObjectType.rectangle;

        for(child in xml) {
            if( valid_element(child)) {
                switch( child.nodeName ) {

                    case "polygon": {
                        object_type = TiledObjectType.polygon;
                        polyobject = polyobject_from_xml(child);
                    } //polygon

                    case "polyline": {
                        object_type = TiledObjectType.polyline;
                        polyobject = polyobject_from_xml(child);
                    } //polyline

                    case "ellipse": {
                        object_type = TiledObjectType.ellipse;
                            //ellipse makes more sense as a centered object
                        var _mid_x : Int = Std.int(width/2);
                        var _mid_y : Int = Std.int(height/2);

                        pos.x += _mid_x;
                        pos.y += _mid_y;

                    } //ellipse

                    case "properties" : {
                        for( property in child ) {
                            if(valid_element(property)) {
                                properties.set(property.get("name"), property.get("value"));
                            }
                        } //each property
                    } //properties

                } //switch child nodename
            }
        } //for each child node

    } //from_xml

    public function from_json( json:Dynamic ) {

        var _gid = Reflect.field(json, "gid");
        gid = _gid != null ? cast _gid : 0;

        id = cast Reflect.field(json, "id");
        name = Reflect.field(json, "name");
        type = Reflect.field(json, "type");
        visible = cast Reflect.field(json, "visible");
        pos.x = cast Reflect.field(json, "x");
        pos.y = cast Reflect.field(json, "y");
        width = cast Reflect.field(json, "width");
        height = cast Reflect.field(json, "height");

        var _rotation = Reflect.field(json, "rotation");
        rotation = _rotation != null ? cast _rotation : 0;

        //default to rectangle
        object_type = TiledObjectType.rectangle;

        var fields = Reflect.fields(json);
        for( nodename in fields ) {
            var child = Reflect.field(json, nodename);
                switch( nodename ) {

                    case "polygon": {
                        object_type = TiledObjectType.polygon;
                        polyobject = polyobject_from_json(child);
                    } //polygon

                    case "polyline": {
                        object_type = TiledObjectType.polyline;
                        polyobject = polyobject_from_json(child);
                    } //polyline

                    case "ellipse": {
                        object_type = TiledObjectType.ellipse;
                            //ellipse makes more sense as a centered object
                        var _mid_x : Int = Std.int(width/2);
                        var _mid_y : Int = Std.int(height/2);

                        pos.x += _mid_x;
                        pos.y += _mid_y;

                    } //ellipse

                    case "properties" : {
                        var child_fields = Reflect.fields(child);
                        for (property_name in child_fields) {
                            properties.set(property_name, Reflect.field(child, property_name));
                        } //for each property
                    } //properties

                } //switch child nodename
        } //for each child node

    } //from_xml

} //TiledObject

class TiledObjectGroup {

    public var map : TiledMapData;
    public var name : String = '';

    public var width : Int = 0;
    public var height : Int = 0;
    public var visible : Bool = true;
    public var opacity : Float = 1.0;
    public var color:String = '';
    public var properties:Map<String, String>;
    public var objects : Array<TiledObject>;

    public function new( _map:TiledMapData ) {
        map = _map;

        properties = new Map();
        objects = [];

    } //new

    public function from_xml( xml:Xml ) {

        name = xml.get("name");
        color = xml.get("color");
        visible = xml.get("visible") != "0";
        opacity = xml.get("opacity") == null ? 1 : Std.parseFloat(xml.get("opacity"));
        width = Std.parseInt(xml.get("width"));
        height = Std.parseInt(xml.get("height"));

        for( child in xml ) {
            if( valid_element(child) ) {

                if( child.nodeName == "properties" ) {
                    for( property in child)  {
                        if( valid_element(property) ) {
                            properties.set(property.get("name"), property.get("value"));
                        } //is valid property node
                    } //for each property
                } //if it's a property node

                if (child.nodeName == "object") {
                    var object:TiledObject = new TiledObject( this );
                        object.from_xml( child );
                    objects.push( object );
                }
            }
        } //for each child
    } //from_xml

    public function from_json( json:Dynamic ) {

        name = Reflect.field(json, "name");
        color = Reflect.field(json, "color");
        visible = cast Reflect.field(json, "visible");
        opacity = Reflect.field(json, "opacity");
        width = cast Reflect.field(json, "width");
        height = cast Reflect.field(json, "height");

        var fields = Reflect.fields(json);
        for( nodename in fields ) {
            var child = Reflect.field(json, nodename);
                switch( nodename ) {

                    case "objects": {
                        var list : Array<Dynamic> = cast child;
                        for(_object_json in list) {

                            var object:TiledObject = new TiledObject( this );
                                object.from_json( _object_json );
                            objects.push( object );

                        } //object_json in list

                    } //object

                    case "properties" : {
                        var child_fields = Reflect.fields(child);
                        for (property_name in child_fields) {
                            properties.set(property_name, Reflect.field(child, property_name));
                        } //for each property
                    } //properties

                } //switch
        } //for each field
    } //from_json


} //TiledObjectGroup
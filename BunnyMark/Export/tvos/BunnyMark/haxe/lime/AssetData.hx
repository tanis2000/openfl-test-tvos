package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/grass.png", "assets/grass.png");
			type.set ("assets/grass.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/pirate.png", "assets/pirate.png");
			type.set ("assets/pirate.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/wabbit_alpha.png", "assets/wabbit_alpha.png");
			type.set ("assets/wabbit_alpha.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("__manifest__", "manifest");
			type.set ("__manifest__", Reflect.field (AssetType, "text".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData

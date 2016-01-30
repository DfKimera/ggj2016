package game {
	public class Assets {

		[Embed(source="../../assets/grass.png")]
		public static var TEXTURE_GRASS:Class;

		[Embed(source="../../assets/unit_sample_60x65.png")]
		public static var UNIT_SAMPLE:Class;

		[Embed(source="../../assets/sample_map_Graphics.csv", mimeType="application/octet-stream")]
		public static var MAP_SAMPLE_GFX:Class;

		[Embed(source="../../assets/sample_map_Collision.csv", mimeType="application/octet-stream")]
		public static var MAP_SAMPLE_COLLISION:Class;

		[Embed(source="../../assets/sample_tiles.png")]
		public static var TILES_SAMPLE:Class;

		[Embed(source="../../assets/tiles_collision.png")]
		public static var TILES_COLLISION:Class;

		[Embed(source="../../assets/selection_marker.png")]
		public static var SELECTION_MARKER:Class;

		[Embed(source="../../assets/hit.mp3")]
		public static var AUDIO_HIT_1:Class;

		public static function getUnitByType(type:String):Class {
			var asset:Class = Assets["UNIT_" + type.replace('/', '_').toUpperCase()];

			if(!asset) {
				trace("[assets.WARNING] could not find unit sprites for type ", type, ", using generic");
				return UNIT_SAMPLE;
			}

			return asset;
		}

	}
}

package game {
	public class Assets {

		[Embed(source="../../assets/grass.png")]
		public static var TEXTURE_GRASS:Class;

		[Embed(source="../../assets/unit_sample.png")]
		public static var UNIT_SAMPLE:Class;

		[Embed(source="../../assets/sample_map.csv", mimeType="application/octet-stream")]
		public static var MAP_SAMPLE:Class;

		[Embed(source="../../assets/sample_tiles.png")]
		public static var TILES_SAMPLE:Class;

		public static function getUnitByType(type:String):Class {
			return Assets["UNIT_" + type.replace('/', '_').toUpperCase()];
		}

	}
}

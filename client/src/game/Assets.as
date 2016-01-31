package game {
	import engine.services.Log;

	public class Assets {

		[Embed(source="../../assets/unit_shaman.png")]
		public static var UNIT_SHAMAN:Class;

		[Embed(source="../../assets/age_of_rites.tmx", mimeType="application/octet-stream")]
		public static var LEVEL_FILE:Class;

		[Embed(source="../../assets/age_of_rites_Collision.csv", mimeType="application/octet-stream")]
		public static var LEVEL_FILE_COLLISION:Class;

		[Embed(source="../../assets/age_of_rites_Graphics.csv", mimeType="application/octet-stream")]
		public static var LEVEL_FILE_TERRAIN:Class;

		[Embed(source="../../assets/tiles_terrain.png")]
		public static var TILES_TERRAIN:Class;

		[Embed(source="../../assets/tiles_collision.png")]
		public static var TILES_COLLISION:Class;

		[Embed(source="../../assets/tree_1.png")]
		public static var TREE_1:Class;

		[Embed(source="../../assets/tree_2.png")]
		public static var TREE_2:Class;

		[Embed(source="../../assets/structure_town_center.png")]
		public static var STRUCTURE_TOWN_CENTER:Class;

		[Embed(source="../../assets/structure_altar.png")]
		public static var STRUCTURE_ALTAR:Class;

		[Embed(source="../../assets/structure_bones.png")]
		public static var STRUCTURE_BONES:Class;

		[Embed(source="../../assets/structure_wheat_field.png")]
		public static var STRUCTURE_WHEAT_FIELD:Class;

		[Embed(source="../../assets/selection_marker.png")]
		public static var SELECTION_MARKER:Class;

		[Embed(source="../../assets/hit.mp3")]
		public static var AUDIO_HIT_1:Class;

		public static function getUnitByType(type:String):Class {
			var asset:Class = Assets["UNIT_" + type.replace('/', '_').toUpperCase()];

			if(!asset) {
				Log.write("[assets.WARNING] could not find unit sprites for type ", type, ", using generic");
				return UNIT_SHAMAN;
			}

			return asset;
		}

		public static function getStructureByType(type:String):Class {
			var asset:Class = Assets[type.replace('/', '_').toUpperCase()];

			if(!asset) {
				Log.write("[assets.WARNING] could not find structure sprites for type ", type, ", using generic");
				return STRUCTURE_BONES;
			}

			return asset;
		}

	}
}

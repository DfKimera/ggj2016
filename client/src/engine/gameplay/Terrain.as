package engine.gameplay {

	import game.Assets;

	import org.flixel.FlxTilemap;

	public class Terrain extends FlxTilemap {

		public static function load():Terrain {
			var terrain:Terrain = new Terrain();
			terrain.loadMap(new Assets.LEVEL_FILE_TERRAIN, Assets.TILES_TERRAIN, 32, 32, 0, 0, 0, 1024);
			return terrain;
		}

	}
}

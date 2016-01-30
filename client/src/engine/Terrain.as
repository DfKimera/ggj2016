package engine {
	import game.Assets;

	import org.flixel.FlxObject;

	import org.flixel.FlxTilemap;

	public class Terrain extends FlxTilemap {

		public function Terrain() {
			super();

			loadMap(new Assets.MAP_SAMPLE, Assets.TILES_SAMPLE, 32, 32);
		}

	}
}

package engine.gameplay {

	import game.Assets;
	import org.flixel.FlxTilemap;

	public class Terrain extends FlxTilemap {

		public function Terrain() {
			super();

			loadMap(new Assets.MAP_SAMPLE_GFX, Assets.TILES_SAMPLE, 32, 32, 0, 0, 1, 1024);
		}

	}
}

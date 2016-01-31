package engine.gameplay {
	import engine.*;
	import game.Assets;

	import mx.utils.StringUtil;
	import org.flixel.FlxTilemap;

	public class Grid extends FlxTilemap {

		public function Grid(terrain:Terrain) {
			super();

			loadMap(new Assets.MAP_SAMPLE_COLLISION, Assets.TILES_COLLISION, 32, 32, 0, 0, 1, 1);
		}


	}
}

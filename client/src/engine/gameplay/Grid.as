package engine.gameplay {

	import game.Assets;

	import org.flixel.FlxTilemap;

	public class Grid extends FlxTilemap {

		public static function load():Grid {
			var grid:Grid = new Grid();
			grid.loadMap(new Assets.LEVEL_FILE_COLLISION, Assets.TILES_COLLISION, 32, 32, 0, 0, 2, 1);
			return grid;
		}


	}
}

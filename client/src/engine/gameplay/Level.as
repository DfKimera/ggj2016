package engine.gameplay {

	import engine.services.Log;
	import engine.states.RTSMatch;

	import game.Assets;

	import io.arkeus.tiled.TiledLayer;

	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledObject;
	import io.arkeus.tiled.TiledObjectLayer;
	import io.arkeus.tiled.TiledReader;
	import io.arkeus.tiled.TiledTileLayer;
	import io.arkeus.tiled.TiledTileset;

	public class Level {

		public var loader:TiledReader;
		public var level:TiledMap;
		public var terrain:Terrain;
		public var grid:Grid;

		public var match:RTSMatch;

		public function Level(match:RTSMatch) {

			this.match = match;

			loader = new TiledReader();
			level = loader.loadFromEmbedded(Assets.LEVEL_FILE);

			this.loadLayers();

		}

		public function loadLayers():void {

			var tilesetStructures:TiledTileset = level.tilesets.getTilesetByName("structures");

			terrain = Terrain.load();
			grid = Grid.load();

			if(!tilesetStructures) {
				Log.write("[level.load.ERROR] Missing tileset type: structures");
				return;
			}

			var layers:Vector.<TiledLayer> = level.layers.getObjectLayers();

			for each(var layer:TiledLayer in layers) {
				switch(layer.name) {

					case "Structures":
						Log.write("[level.load] Loading STRUCTURES list: ", layer);

						if(!(layer is TiledObjectLayer)) {
							Log.write("[level.load.ERROR] Cannot load STRUCTURES list: layer is not an object layer!");
						} else {
							this.loadStructures(layer as TiledObjectLayer, tilesetStructures);
						}

						break;

					default:
						Log.write("[level.load.WARNING] Invalid layer in map file: ", layer.name);
						break;
				}
			}

		}

		public function loadStructures(layer:TiledObjectLayer, tileset:TiledTileset):void {
			Log.write("[level.load] Structure tileset:", tileset);

			for each(var object:TiledObject in layer.objects) {
				var objectIndex:String = String(object.gid - tileset.firstGid);
				var objectType:Object = tileset.tiles[objectIndex];

				if(!objectType || !objectType.image) {
					Log.write("[level.load.WARNING] Invalid object type: ", objectIndex);
					continue;
				}

				Structure.loadedFromMap(int(objectIndex), String(objectType.image.source).replace(".png",""), int(object.x), int(object.y), int(objectType.image.width), int(objectType.image.height), match);
			}
		}
	}
}

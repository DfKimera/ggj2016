package engine.gameplay {

	import engine.services.Log;
	import engine.states.RTSMatch;

	import game.Assets;

	import org.flixel.FlxSprite;

	public class Structure extends Entity {

		public var type:String;

		public static const SERVER_STRUCTURES:Array = ['structure_town_center', 'structure_altar', 'structure_wheat_field'];

		public function Structure(id:int, owner:int, type:String, x:Number, y:Number, match:RTSMatch) {
			super(id, owner, x, y, match);

			this.type = type;
			this.loadGraphic(Assets.getStructureByType(type));
		}

		public override function toString():String {
			return "<Structure:" + type + ":" + owner + "; id=" + id + "; type=" + type + "; pos=" + x + "," + y + ">";
		}

		public static function loadedFromMap(index:int, objectType:String, x:int, y:int, width:int, height:int, match:RTSMatch):void {

			if(SERVER_STRUCTURES.indexOf(objectType) == -1) { // local props
				Log.write("[local] Spawn prop: ", objectType, x, y, width, height);

				var prop:FlxSprite = new FlxSprite(x, y - height, Assets.getStructureByType(objectType));
				match.spawnProp(prop);

				return;
			}

			if(match.getLocalPlayer().isHost) {
				Log.write("[host] Sending structure spawn: ", objectType, x, y, width, height);
				match.multi.sendStructureSpawn(objectType, x, y - height);
			} else {
				Log.write("[local] Skipping host-only structure: ", objectType, x, y, width, height);
			}

		}
	}
}

package engine {
	import game.Assets;

	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Unit extends FlxExtendedSprite {

		public var id:int;
		public var type:String;

		public function Unit(id:int, type:String, x:int, y:int) {
			this.id = id;
			this.type = type;

			super(x, y);

			loadGraphic(Assets.getUnitByType(type), true, false, 120, 130);

			addAnimation("idle_south", [0,0,0,0,0,0,0,0,0,0,0,0,1,2,1], 10);
			addAnimation("idle_west", [10,10,10,10,10,10,10,10,10,10,10,10,11,12,11], 10);
			addAnimation("idle_north", [20], 10);
			addAnimation("idle_east", [30,30,30,30,30,30,30,30,30,30,30,30,31,32,31], 10);

			addAnimation("walk_south", [40,41,42,43,44,45,46,47,48,49], 30);
			addAnimation("walk_west", [50,51,52,53,54,55,56,57,58,59], 30);
			addAnimation("walk_north", [60,61,62,63,64,65,66,67,68,69], 30);
			addAnimation("walk_east", [70,71,72,73,74,75,76,77,78,79], 30);

			play("idle_south");
		}
	}
}

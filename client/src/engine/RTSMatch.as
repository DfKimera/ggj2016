package engine {
	import engine.Terrain;

	import org.flixel.FlxState;

	public class RTSMatch extends FlxState {

		public var terrain:Terrain;

		public override function create():void {
			terrain = new Terrain();
			add(terrain);

			var unit:Unit = new Unit(1, "sample", 100, 150);
			add(unit);
		}

	}
}

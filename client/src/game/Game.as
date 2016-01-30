package game {

	import engine.RTSMatch;
	import engine.RightClick;

	import org.flixel.FlxG;

	import org.flixel.FlxGame;
	import org.flixel.plugin.photonstorm.FlxMouseControl;

	public class Game extends FlxGame {

		public function Game() {
			super(1024, 768, RTSMatch, 1, 60, 30, true);

			setupEnginePlugins();
		}

		public function setupEnginePlugins():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
		}

		protected override function update():void {
			super.update();
			RightClick.clearLastFrame();
		}

	}
}

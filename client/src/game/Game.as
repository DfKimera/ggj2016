package game {

	import engine.states.Matchmaking;
	import engine.services.RightClick;

	import flash.events.Event;

	import org.flixel.FlxG;

	import org.flixel.FlxGame;
	import org.flixel.plugin.photonstorm.FlxMouseControl;

	public class Game extends FlxGame {

		public function Game() {
			super(1024, 768, Matchmaking, 1, 60, 30, true);

			setupEnginePlugins();
		}

		protected override function create(ev:Event):void {
			super.create(ev);

			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
			stage.removeEventListener(Event.ACTIVATE, onFocus);
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

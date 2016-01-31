package engine.services {
	import flash.external.ExternalInterface;

	import game.Config;

	import org.flixel.FlxG;

	public class Log {

		public static var log:Array = [];

		public static function write(... args):void {
			trace.apply(args);

			if(ExternalInterface.available) {
				ExternalInterface.call("console.log", args.join("\t"));
			}

			if(Config.LOG_SHOW) {
				FlxG.log(args.join("\t"));
			}
		}

		/**
		 * TODO: chat window in-game with enter-type-enter flow
		 * TODO: show these messages log in chat, when ingame
		 * TODO: bugs when 3 players join, one is kicked: the kicked player is not moved to the menu, and the lobby is
		 * stuck before starting (two readies are not enough)
		 * TODO: investigate bug where clicking the "spawn unit" does not spawn on both clients
		 * TODO: resourcing system, with yield rates per structure, and the structures require workers working (should
		 * have same functionality as unit-attack-unit, but unit-harvest-structure
		 * [OKK, CHECK] TODO: disable collision when unit is mid-path, to reduce potential for desync
		 * TODO: block from selection the units that are not owned by you
		 * TODO: player base structure, is the waypoint to spawn new units
		 * TODO: predefined spots in the server for player bases
		 * TODO: focus camera on player base
		 * TODO: write relic endgame system (possibly: structure Relic yields resource Faith until depleted)
		 * TODO: think about ranged combat (?)
		 */
	}
}

package game {
	import engine.UnitStats;

	import game.stats.PeasantStats;

	public class Stats {

		private static var unitStats:Array = [];

		public static function getForUnit(type:String):UnitStats {
			switch(type) {
				case "peasant": return (unitStats[type]) ? unitStats[type] : (unitStats[type] = new PeasantStats());
				case "generic":
				default: return (unitStats[type]) ? unitStats[type] : (unitStats[type] = new UnitStats());
			}
		}
	}
}

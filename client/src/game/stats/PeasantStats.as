package game.stats {
	import engine.gameplay.UnitStats;
	import engine.services.Log;

	public class PeasantStats extends UnitStats {
		public function PeasantStats() {

			Log.write("[stats] Loaded stats for Peasant");

			name = "Peasant";

			health = 100;

			attackDistance = 64;
			attackRate = 20;
			attackCooldown = 0;
			attackDamage = 10;

			huntTimeout = 50;

			speed = 300;

		}
	}
}

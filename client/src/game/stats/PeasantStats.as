package game.stats {
	import engine.gameplay.UnitStats;
	import engine.services.Log;

	public class PeasantStats extends UnitStats {
		public function PeasantStats() {

			Log.write("[stats] Loaded stats for Peasant");

			name = "Peasant";

			health = 100;

			attackDistance = 64;
			attackCooldown = 15;
			attackDamage = 10;

			huntCooldown = 50;

			walkSpeed = 300;

		}
	}
}

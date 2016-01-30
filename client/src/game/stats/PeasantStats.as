package game.stats {
	import engine.UnitStats;

	public class PeasantStats extends UnitStats {
		public function PeasantStats() {

			trace("[stats] Loaded stats for Peasant");

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

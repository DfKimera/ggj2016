package {
	import org.flixel.system.FlxPreloader;

	public class Preloader extends FlxPreloader {
		public function Preloader() {
			className = "Bootstrap";
			minDisplayTime = 1;
			super();
		}
	}
}

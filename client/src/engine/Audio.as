package engine {

	import game.Assets;

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;

	public class Audio {

		public static var tracks:Array = [];
		public static var channels:Array = [];

		public static function setup():void {

			tracks['hit'] = Assets.AUDIO_HIT_1;

		}

		public static function getTrack(track:String):FlxSound {
			if(!tracks[track]) return null;
			return FlxG.loadSound(tracks[track]);
		}

		public static function playInLocalArea(sound:FlxSound, source:FlxObject, radius:int = 1024):void {
			trace("[audio] Play: ", sound, source, radius);
			sound.proximity(FlxG.camera.scroll.x + (FlxG.width / 2), FlxG.camera.scroll.y + (FlxG.height / 2), source, radius).play(true);
		}

	}
}

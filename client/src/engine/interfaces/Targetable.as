package engine.interfaces {
	import engine.gameplay.Entity;

	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;

	public interface Targetable extends Damageable {
		function getMidpoint(point:FlxPoint = null):FlxPoint;
		function isAlive():Boolean;
	}
}

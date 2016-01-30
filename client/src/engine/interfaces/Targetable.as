package engine.interfaces {
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;

	public interface Targetable {
		function getMidpoint(point:FlxPoint = null):FlxPoint;
		function onDamage(attacker:FlxBasic, damage:int):void;
		function isAlive():Boolean;
	}
}

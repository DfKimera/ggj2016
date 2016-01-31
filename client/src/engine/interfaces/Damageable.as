package engine.interfaces {
	import engine.gameplay.Entity;

	public interface Damageable {
		function getID():int;
		function onDamage(inflicter:Entity, damage:int):void;
		function onDeath():void;
	}
}

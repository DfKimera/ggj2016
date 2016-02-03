package engine.interfaces {
	import engine.gameplay.Entity;

	public interface Damageable {
		function getID():int;
		function onDamaged(inflicter:Entity, damage:int):void;
		function onDeath():void;
	}
}

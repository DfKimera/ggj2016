package engine {

	import engine.interfaces.Selectable;
	import engine.interfaces.Targetable;

	import org.flixel.FlxBasic;

	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Structure extends FlxExtendedSprite implements Targetable, Selectable {

		public var id:int;
		public var owner:int;
		public var type:String;

		public function Structure(id:int, owner:int, type:String, x:Number, y:Number) {
			this.id = id;
			this.owner = owner;
			this.type = type;

			super();

			this.x = x;
			this.y = y;
		}

		public function onDamage(attacker:FlxBasic, damage:int):void {
			if(!alive) return;

			trace("[combat] ", this, " took ", damage, " damage from ", attacker);

			health -= damage;

			if(health <= 0) {
				onDeath();
			}
		}

		public function onDeath():void {
			if(!alive) return;

			trace("[combat] ", this, " is dead");

			alive = false;
			solid = false;

			alpha = 0.5;
		}

		public function isAlive():Boolean {
			return true;
		}

		public function onSelect():void {

		}

		public function onDeselect():void {

		}

		public function onCommand(command:int, parameters:Array):void {

		}

		public override function toString():String {
			return "<Structure:" + type + ":" + owner + "; id=" + id + "; type=" + type + "; pos=" + x + "," + y + ">";
		}
	}
}

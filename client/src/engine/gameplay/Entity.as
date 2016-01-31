package engine.gameplay {

	import engine.interfaces.Selectable;
	import engine.interfaces.Targetable;

	import engine.states.RTSMatch;

	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Entity extends FlxExtendedSprite implements Targetable, Selectable {

		private static var _entitiesByID:Array = [];

		public var id:int;
		public var owner:int;

		protected var match:RTSMatch;

		public var bodyDecay:int = 400;
		public var isSelected:Boolean = false;

		public function Entity(id:int, owner:int, x:Number, y:Number, match:RTSMatch) {
			super(x, y);

			this.id = id;
			this.owner = owner;

			this.match = match;

			register(this);
		}

		protected function debug(namespace:String, ... args):void {
			args.unshift("[" + namespace + "] ");
			args.unshift(this);
			trace.apply(this, args);
		}

		public function isLocal():Boolean {
			return (owner == match.getLocalPlayerID());
		}

		public function onCommand(command:int, parameters:Array):void {

		}

		public function getID():int {
			return id;
		}

		public function isAlive():Boolean {
			return alive;
		}

		public function onAttack(target:Entity, damage:int):void {
			if(!alive) return;

			debug("combat", " inflicted ", damage, " damage to ", target);

			target.onDamage(this, damage);
		}

		public function onDamage(attacker:Entity, damage:int):void {
			if(!alive) return;

			debug("combat", " took ", damage, " damage from ", attacker);

			health -= damage;

			if(health <= 0) {
				onDeath();
			}
		}

		public function onDeath():void {
			if(!alive) return;

			debug("combat", this, " is dead");

			isSelected = false;
			exists = false;
			alive = false;
			solid = false;

			alpha = 0.5;
		}

		public function onSelect():void {
			if(!alive) return;

			debug("selection", "is selected");
			isSelected = true;
		}

		public function onDeselect():void {
			if(!alive) return;

			debug("selection", "deselected");
			isSelected = false;
		}

		public static function register(ent:Entity):void {
			if(_entitiesByID[ent.id]) return;
			_entitiesByID[ent.id] = ent;
		}

		public static function getByID(id:int):Entity {
			return _entitiesByID[id];
		}
	}
}

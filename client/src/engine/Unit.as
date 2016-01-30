package engine {

	import engine.interfaces.Selectable;
	import engine.interfaces.Targetable;

	import game.Assets;
	import game.Stats;

	import org.flixel.FlxBasic;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;

	import org.flixel.FlxPath;

	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;

	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Unit extends FlxExtendedSprite implements Targetable, Selectable {

		public static const TASK_IDLE:int = 0;
		public static const TASK_MOVE:int = 1;
		public static const TASK_ATTACK:int = 2;
		public static const TASK_HARVEST:int = 3;

		public static const ACTION_STANDING:int = 1;
		public static const ACTION_MOVING:int = 2;
		public static const ACTION_WORKING:int = 3;

		public static const COMMAND_MOVE:int = 1;
		public static const COMMAND_ATTACK:int = 2;
		public static const COMMAND_STOP:int = 3;

		public var id:int;
		public var owner:int;
		public var type:String;
		public var direction:int = DOWN;

		public var sfxHit:FlxSound;

		public var stats:UnitStats;
		public var grid:Grid;
		public var group:FlxGroup;

		public var attackCooldown:Number = 0;
		public var huntCooldown:Number = 0;
		public var bodyDecay:int = 400;

		public var currentTask:int = TASK_IDLE;
		public var currentAction:int = ACTION_STANDING;
		public var currentTarget:Targetable = null;

		public var isSelected:Boolean = false;
		private var selection:Selection;

		public function Unit(id:int, owner:int, type:String, x:int, y:int, grid:Grid, selection:Selection, group:FlxGroup) {
			this.id = id;
			this.type = type;
			this.owner = owner;

			this.grid = grid;
			this.selection = selection;
			this.group = group;

			this.stats = Stats.getForUnit(type);

			super(x, y);

			this.health = stats.health;
			this.mass = stats.mass;
			this.drag = new FlxPoint(stats.drag, stats.drag);
			this.elasticity = 0;
			this.sfxHit = Audio.getTrack('hit');

			this.clickable = true;
			this.enableMouseClicks(true, false);
			this.mousePressedCallback = handleUnitClick;

			loadGraphic(Assets.getUnitByType(type), true, false, 60, 65);

			setupCollisionOffset();

			addAnimation("idle_down", [0], 10); //,0,0,0,0,0,0,0,0,0,0,0,1,2,1], 10);
			addAnimation("idle_left", [10], 10); //,10,10,10,10,10,10,10,10,10,10,10,11,12,11], 10);
			addAnimation("idle_up", [20], 10);
			addAnimation("idle_right", [30], 10); //,30,30,30,30,30,30,30,30,30,30,30,31,32,31], 10);

			addAnimation("walk_down", [40,41,42,43,44,45,46,47,48,49], 20);
			addAnimation("walk_left", [50,51,52,53,54,55,56,57,58,59], 20);
			addAnimation("walk_up", [60,61,62,63,64,65,66,67,68,69], 20);
			addAnimation("walk_right", [70,71,72,73,74,75,76,77,78,79], 20);

		}

		private function debug(namespace:String, ... args):void {
			args.unshift("[" + namespace + "] ");
			args.unshift(this);
			trace.apply(this, args);
		}


		public function setupCollisionOffset():void {
			offset.x = 15;
			offset.y = 36;
			width = 30;
			height = 30;
		}

		public function follow(path:FlxPath):void {
			if(this.path) {
				debug("moving", "cancelling existing path");
				this.stopFollowingPath(true);
			}

			if(!path) return;

			debug("moving", " following path ", path.nodes, stats.speed);

			currentTask = TASK_MOVE;
			currentAction = ACTION_MOVING;

			this.followPath(path, stats.speed, PATH_FORWARD, false);
		}

		public function attack(target:Targetable):void {

			if(this.path) {
				this.stopFollowingPath(true);
			}

			currentTask = TASK_ATTACK;
			currentTarget = target;

			debug("combat", "going to attack", target);
		}

		public override function update():void {
			super.update();

			if(!alive) {
				handleBodyDecay();
				return;
			}

			handleAnimations();
			handleTasks();
		}

		private function handleAnimations():void {
			switch(currentAction) {
				case ACTION_MOVING:
					renderAnimation('walk');
					break;
				case ACTION_WORKING:
				case ACTION_STANDING:
				default:
					renderAnimation('idle');
					break;
			}
		}

		private function handleTasks():void {
			switch(currentTask) {
				case TASK_MOVE:
					taskMove();
					break;
				case TASK_ATTACK:
					taskAttack();
					break;
				default:
				case TASK_IDLE:
					taskIdle();
					break;
			}
		}

		private function handleBodyDecay():void {
			if(bodyDecay <= 0) {
				this.group.remove(this);
				exists = false;
			}

			bodyDecay--;
		}

		private function taskMove():void {
			resolveDirection();
			renderAnimation('walk');

			if(pathSpeed == 0 || path.nodes.length <= 0) {
				debug("moving", "arrived at destination");
				currentTask = TASK_IDLE;
				currentAction = ACTION_STANDING;

				renderAnimation('idle');
				stopFollowingPath(true);
			}

		}

		private function taskAttack():void {
			var distance:Number = FlxU.getDistance(this.getMidpoint(), this.currentTarget.getMidpoint());

			if(!currentTarget.isAlive()) {
				debug("combat", "target ", currentTarget, " is dead, becoming idle");
				currentTask = TASK_IDLE;
				return;
			}

			if(distance <= stats.attackDistance) {
				currentAction = ACTION_WORKING;

				if(attackCooldown <= 0) {
					debug("combat", "hitting ", currentTarget, " with ", stats.attackDamage);
					currentTarget.onDamage(this, stats.attackDamage);
					attackCooldown = 1000 / stats.attackRate;
				}

				attackCooldown--;

			} else {
				attackCooldown = 1000 / stats.attackRate;
				currentAction = ACTION_MOVING;


				if(huntCooldown <= 0) {
					debug("combat", "tracking new route towards ", currentTarget);

					huntCooldown = stats.huntTimeout;

					if(pathSpeed == 0 || (path && path.nodes.length <= 0)) stopFollowingPath(true);

					var path:FlxPath = grid.findPath(this.getMidpoint(), currentTarget.getMidpoint());

					if(!path) {
						debug("combat", "no path found! will try again next time", currentTarget);
						return;
					}

					debug("combat", "new path to target", currentTarget, path);

					this.followPath(path, stats.speed, PATH_FORWARD, false);
				}

				huntCooldown--;

			}
		}

		private function taskIdle():void {
			currentAction = ACTION_STANDING;
		}

		public override function draw():void {
			super.draw();
		}

		public function resolveDirection():int {
			if(velocity.y < 0) return direction = UP;
			if(velocity.x < 0) return direction = LEFT;
			if(velocity.x > 0) return direction = RIGHT;
			return direction = DOWN;
		}

		public function renderAnimation(anim:String):void {
			switch(direction) {
				case LEFT: return play(anim + "_left");
				case RIGHT: return play(anim + "_right");
				case UP: return play(anim + "_up");
				case DOWN: return play(anim + "_down");
			}
		}

		public function isAlive():Boolean {
			return alive;
		}

		public function onDamage(attacker:FlxBasic, damage:int):void {
			if(!alive) return;

			debug("combat", " took ", damage, " damage from ", attacker);

			Audio.playInLocalArea(sfxHit, this);

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

		public function onCommand(command:int, parameters:Array):void {

			switch(command) {
				case COMMAND_MOVE:
					var moveTarget:FlxPoint = parameters[0] as FlxPoint;

					debug("command", "move towards", moveTarget);
					if(!moveTarget) { trace("command.ERROR", "Invalid target for move command"); }

					var path:FlxPath = grid.findPath(this.getMidpoint(), moveTarget, false, false);

					this.follow(path);

					break;
				case COMMAND_ATTACK:
					var attackTarget:Targetable = parameters[0] as Targetable;

					debug("command", "attack", attackTarget);
					if(!attackTarget) { debug("command.ERROR", "Invalid attack target"); }

					this.attack(attackTarget);

					break;
			}

		}

		public override function toString():String {
			return "<Unit:" + type + ":" + owner + "; id=" + id + "; pos=" + x + "," + y + ">";
		}

		public static function handleUnitClick(unit:Unit, x:Number, y:Number):void {
			if(FlxG.keys.SHIFT) {
				unit.selection.addUnitToSelection(unit);
				return;
			}

			unit.selection.selectUnit(unit);
		}
	}
}

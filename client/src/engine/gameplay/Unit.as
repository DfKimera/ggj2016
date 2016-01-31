package engine.gameplay {


	import engine.interfaces.Selectable;
	import engine.interfaces.Targetable;
	import engine.services.Audio;
	import engine.states.RTSMatch;

	import game.Assets;
	import game.Stats;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;

	import org.flixel.FlxPath;

	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;


	public class Unit extends Entity {

		public static const TASK_IDLE:int = 0;
		public static const TASK_MOVE:int = 1;
		public static const TASK_ATTACK:int = 2;
		public static const TASK_HARVEST:int = 3;

		public static const ACTION_STANDING:int = 1;
		public static const ACTION_MOVING:int = 2;
		public static const ACTION_WORKING:int = 3;
		public static const ACTION_ATTACKING:int = 4;

		public static const COMMAND_MOVE:int = 1;
		public static const COMMAND_ATTACK:int = 2;
		public static const COMMAND_STOP:int = 3;

		public var type:String;
		public var direction:int = DOWN;

		public var sfxHit:FlxSound;

		public var stats:UnitStats;
		public var grid:Grid;
		public var group:FlxGroup;

		public var attackCooldown:Number = 0;
		public var huntCooldown:Number = 0;

		public var currentTask:int = TASK_IDLE;
		public var currentAction:int = ACTION_STANDING;
		public var currentTarget:Targetable = null;


		private var selection:Selection;

		public function Unit(id:int, owner:int, type:String, x:int, y:int, match:RTSMatch) {
			super(id, owner, x, y, match);

			this.type = type;

			this.grid = match.grid;
			this.selection = match.selection;
			this.group = match.$units;

			this.stats = Stats.getForUnit(type);
			this.sfxHit = Audio.getTrack('hit');

			loadGraphic(Assets.getUnitByType(type), true, false, 60, 65);

			setupMouseClick();
			setupCollision();
			setupAnimations();

		}

		public function setupMouseClick():void {
			this.clickable = true;
			this.enableMouseClicks(true, false);
			this.mousePressedCallback = handleUnitClick;
		}

		public function setupAnimations():void {
			addAnimation("idle_down", [0], 10); //,0,0,0,0,0,0,0,0,0,0,0,1,2,1], 10);
			addAnimation("idle_left", [10], 10); //,10,10,10,10,10,10,10,10,10,10,10,11,12,11], 10);
			addAnimation("idle_up", [20], 10);
			addAnimation("idle_right", [30], 10); //,30,30,30,30,30,30,30,30,30,30,30,31,32,31], 10);

			addAnimation("walk_down", [40,41,42,43,44,45,46,47,48,49], 20);
			addAnimation("walk_left", [50,51,52,53,54,55,56,57,58,59], 20);
			addAnimation("walk_up", [60,61,62,63,64,65,66,67,68,69], 20);
			addAnimation("walk_right", [70,71,72,73,74,75,76,77,78,79], 20);
		}

		public function setupCollision():void {
			this.health = stats.health;
			this.mass = stats.mass;
			this.drag = new FlxPoint(stats.drag, stats.drag);
			this.elasticity = 0;

			offset.x = 15;
			offset.y = 36;
			width = 30;
			height = 30;
		}

		public function walkOverPath(path:FlxPath):void {
			if(!path) return;

			currentTask = TASK_MOVE;

			match.multi.sendUnitFollow(this, path);
		}

		public function follow(path:FlxPath):void {
			if(this.path) {
				debug("moving", "cancelling existing path");
				this.stopFollowingPath(true);
			}

			if(!path) return;

			debug("moving", " following path ", path.nodes, stats.speed);

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

			resolveDirection();
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
			if(pathSpeed == 0 || path.nodes.length <= 0) {
				debug("moving", "arrived at destination");
				currentTask = TASK_IDLE;
				currentAction = ACTION_STANDING;

				renderAnimation('idle');
				stopFollowingPath(true);
			}

		}

		private function taskAttack():void {
			if(!isLocal()) return;

			var distance:Number = FlxU.getDistance(this.getMidpoint(), this.currentTarget.getMidpoint());

			if(!currentTarget.isAlive()) {
				debug("combat", "target ", currentTarget, " is dead, becoming idle");
				currentTask = TASK_IDLE;
				return;
			}

			if(distance <= stats.attackDistance) {
				currentAction = ACTION_ATTACKING; // TODO: this should be controlled by the chain end; swap onDamage with onAttack

				if(attackCooldown <= 0) {
					debug("combat", "hitting ", currentTarget, " with ", stats.attackDamage);
					match.multi.sendUnitAttack(this, currentTarget, stats.attackDamage);
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

					match.multi.sendUnitFollow(this, path);
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

		public override function onAttack(target:Entity, damage:int):void {
			super.onAttack(target, damage);

			currentAction = ACTION_ATTACKING;
			Audio.playInLocalArea(sfxHit, this);
		}

		public override function onCommand(command:int, parameters:Array):void {

			switch(command) {
				case COMMAND_MOVE:
					var moveTarget:FlxPoint = new FlxPoint(parameters[0], parameters[1]);

					debug("command", "move towards", parameters[0], parameters[1]);
					if(!moveTarget) { debug("command.ERROR", "Invalid target for move command"); }

					var path:FlxPath = grid.findPath(this.getMidpoint(), moveTarget, false, false);

					match.multi.sendUnitFollow(this, path);

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

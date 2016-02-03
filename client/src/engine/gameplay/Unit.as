package engine.gameplay {

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
		public static const TASK_NETWORKED:int = 1;
		public static const TASK_WALK:int = 2;
		public static const TASK_ATTACK:int = 3;
		public static const TASK_GATHER:int = 4;

		public static const ACTION_STOP:int = 1;
		public static const ACTION_FOLLOW_PATH:int = 2;
		public static const ACTION_HIT:int = 3;
		public static const ACTION_GATHER:int = 4;

		public static const COMMAND_WALK:int = 1;
		public static const COMMAND_ATTACK:int = 2;
		public static const COMMAND_GATHER:int = 2;
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
		public var currentAction:int = ACTION_STOP;
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

			currentTask = (isLocal()) ? TASK_IDLE : TASK_NETWORKED;

		}

		public function setupMouseClick():void {
			this.clickable = true;
			this.enableMouseClicks(true, false);
			this.mousePressedCallback = onUnitClick;
		}

		public function setupAnimations():void {
			addAnimation("idle_left", [2], 0);
			addAnimation("idle_down", [7], 0);
			addAnimation("idle_up", [12], 0);
			addAnimation("idle_right", [17], 0);

			addAnimation("walk_left", [0,1,2,3,4], 20);
			addAnimation("walk_down", [5,6,7,8,9], 20);
			addAnimation("walk_up", [10,11,12,13,14], 20);
			addAnimation("walk_right", [15,16,17,18,19], 20);

			addAnimation("attack", [20,20,20,21,21], 8);
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

		public override function toString():String {
			return "<Unit:" + type + ":" + owner + "; id=" + id + "; pos=" + x + "," + y + ">";
		}

		public override function update():void {
			super.update();

			if(!alive) {
				handleBodyDecay();
				return;
			}

			resolveDirection();
			handleAnimations();

			if(isLocal()) {
				handleLocalTasks();
			}
		}

		// ----------------------------------------------------------------------------------------------------
		// Frame handlers
		// ----------------------------------------------------------------------------------------------------

		private function handleAnimations():void {
			switch(currentAction) {
				case ACTION_FOLLOW_PATH:
					renderAnimation('walk');
					break;
				case ACTION_HIT:
				case ACTION_GATHER:
				case ACTION_STOP:
				default:
					renderAnimation('idle');
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

		private function resolveDirection():int {
			if(velocity.y < 0) return direction = UP;
			if(velocity.x < 0) return direction = LEFT;
			if(velocity.x > 0) return direction = RIGHT;
			return direction = DOWN;
		}

		private function renderAnimation(anim:String):void {
			switch(direction) {
				case LEFT: return play(anim + "_left");
				case RIGHT: return play(anim + "_right");
				case UP: return play(anim + "_up");
				case DOWN: return play(anim + "_down");
			}
		}

		// ----------------------------------------------------------------------------------------------------
		// Local actions
		// ----------------------------------------------------------------------------------------------------

		public override function onLocalCommand(command:int, parameters:Array):void {

			switch(command) {
				case COMMAND_WALK:
					var moveTarget:FlxPoint = new FlxPoint(parameters[0], parameters[1]);
					this.beginWalk(moveTarget);

					break;
				case COMMAND_ATTACK:
					var attackTarget:Targetable = parameters[0] as Targetable;
					this.beginAttack(attackTarget);

					break;
			}

		}

		// --------------------
		// local action initiators
		// --------------------

		public function beginIdle():void {
			currentTask = TASK_IDLE;

			match.multi.sendUnitActionStop(this);
		}

		public function beginWalk(target:FlxPoint):void {
			debug('local_command', 'begin walk to ', target.x, target.y);

			var path:FlxPath = grid.findPath(this.getMidpoint(), target, false, false);

			if(!path) {
				debug('local_command', 'no valid path found!');
				return;
			}

			currentTask = TASK_WALK;

			match.multi.sendUnitActionFollowPath(this, path);
		}

		public function beginAttack(target:Targetable):void {
			if(!target) return;

			debug('local_command', 'begin attacking ', target);

			currentTask = TASK_ATTACK;
			currentTarget = target;
		}

		// --------------------
		// local AI cycle
		// --------------------

		private function handleLocalTasks():void {
			switch(currentTask) {
				case TASK_WALK: taskWalk(); break;
				case TASK_ATTACK: taskAttack(); break;
				default: case TASK_IDLE: taskIdle(); break;
			}
		}

		// --------------------
		// local AI task implementations
		// --------------------

		private function taskWalk():void {
			if(currentAction != ACTION_FOLLOW_PATH) return;

			if(pathSpeed == 0 || path.nodes.length <= 0) {
				debug('task.walk', 'arrived at destination, stopping');
				return beginIdle();
			}
		}

		private function taskAttack():void {
			if(!currentTarget.isAlive()) {
				debug('task.attack', 'target is dead, going idle now');
				return beginIdle();
			}

			var distance:Number = FlxU.getDistance(this.getMidpoint(), currentTarget.getMidpoint());

			if(distance <= stats.attackDistance) return taskAttackHit();

			taskAttackHunt();
		}

		private function taskAttackHit():void {
			if(attackCooldown > 0) {
				attackCooldown--;
				return;
			}

			debug('task.attack', 'within hitting range of ', currentTarget, ', hitting with ', stats.attackDamage);

			attackCooldown = stats.attackCooldown;

			match.multi.sendUnitActionHit(this, currentTarget, stats.attackDamage);
		}

		private function taskAttackHunt():void {
			if(huntCooldown > 0) {
				huntCooldown--;
				return;
			}

			debug('task.walk', 'not within range, finding path to ', currentTarget);

			huntCooldown = stats.huntCooldown;

			var pathToTarget:FlxPath = grid.findPath(this.getMidpoint(), currentTarget.getMidpoint(), false, false);
			if(!pathToTarget) return debug('task.walk', 'no path found!');

			debug('task.walk', 'following path to ', currentTarget, pathToTarget);

			match.multi.sendUnitActionFollowPath(this, pathToTarget);
		}

		private function taskIdle():void {

		}

		// --------------------
		// Action local handlers
		// --------------------

		public function actionHit(target:Entity, damage:int):void {
			solid = true;

			debug('action.hit', 'hitting ', damage, ' with ', damage, ' damage');

			if(!target.isAlive()) {
				debug('action.hit', 'cannot hit a dead entity: ', target);
				return;
			}

			currentAction = ACTION_HIT;

			// TODO: add pos?

			this.onDamage(target, damage);
			Audio.playInLocalArea(sfxHit, this);
		}

		public function actionGather(target:Entity):void {
			solid = true;

			debug('action.gather', 'gathering resources from ', target);

			currentAction = ACTION_GATHER;
			Audio.playInLocalArea(sfxHit, this);
		}

		public function actionStop(stopX:int, stopY:int):void {
			solid = true;

			debug('action.stop', 'stopping @ ', stopX, stopY);

			currentAction = ACTION_STOP;

			stopFollowingPath(true);

			x = stopX;
			y = stopY;
		}

		public function actionFollowPath(path:FlxPath):void {
			solid = false;

			debug('action.follow_path', 'following path: ', path, stats.walkSpeed);
			// TODO: add startPos?

			currentAction = ACTION_FOLLOW_PATH;
			followPath(path, stats.walkSpeed);

		}


		// ------------------------------------------------------------------------------------------------------------
		// Static functions
		// ------------------------------------------------------------------------------------------------------------

		public static function onUnitClick(unit:Unit, x:Number, y:Number):void {
			if(FlxG.keys.SHIFT) {
				unit.selection.addUnitToSelection(unit);
				unit.debug('selection', 'added to selection: ', unit.selection.selectedUnits);
				return;
			}

			unit.selection.selectUnit(unit);
			unit.debug('selection', 'is now selected');
		}
	}
}

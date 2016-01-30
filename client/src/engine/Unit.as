package engine {
	import flash.events.Event;

	import game.Assets;

	import org.flixel.FlxG;

	import org.flixel.FlxPath;

	import org.flixel.FlxPoint;

	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Unit extends FlxExtendedSprite {

		public static const TASK_IDLE:int = 0;
		public static const TASK_MOVING:int = 1;

		public static const COMMAND_MOVE = 1;
		public static const COMMAND_ATTACK = 2;
		public static const COMMAND_STOP = 3;

		public var id:int;
		public var owner:int;
		public var type:String;
		public var direction:int = DOWN;
		public var speed:int = 300;

		public var currentTask:int = TASK_IDLE;
		public var isSelected:Boolean = false;

		private var selection:Selection;

		public function Unit(id:int, owner:int, type:String, x:int, y:int, selection:Selection) {
			this.id = id;
			this.type = type;
			this.selection = selection;

			super(x, y);

			this.mass = 1000;
			this.drag = new FlxPoint(10, 10);

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

			play("idle_down");
		}


		public function setupCollisionOffset():void {
			offset.x = 15;
			offset.y = 36;
			width = 30;
			height = 30;
		}

		public function follow(path:FlxPath):void {
			if(this.path) {
				this.stopFollowingPath(true);
			}

			if(!path) return;

			trace("Following path: ", path.nodes, speed);

			currentTask = TASK_MOVING;

			this.followPath(path, speed, PATH_FORWARD, false);
		}

		public override function update():void {
			super.update();

			switch(currentTask) {
				case TASK_MOVING:
					resolveDirection();
					renderAnimation('walk');
					checkPathEnd();
					break;
			}

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

		public function checkPathEnd():void {
			if(pathSpeed == 0 || path.nodes.length <= 0) {
				currentTask = TASK_IDLE;
				renderAnimation('idle');
				stopFollowingPath(true);
			}
		}

		public function onSelect():void {
			trace("Selected: ", this);
			isSelected = true;
		}

		public function onDeselect():void {
			trace("Deselected: ", this);
			isSelected = false;
		}

		public function onCommand(command:int, parameters:Array):void {

			switch(command) {
				case COMMAND_MOVE:
					var moveTarget:FlxPoint = parameters[0] as FlxPoint;
					var grid:Grid = parameters[1] as Grid;

					trace("Unit Move: ", id, moveTarget, grid);

					if(!moveTarget) { trace("INVALID TARGET FOR MOVE COMMAND"); }
					if(!grid) { trace("INVALID GRID FOR MOVE COMMAND"); }

					var path:FlxPath = grid.findPath(this.getMidpoint(), moveTarget, false, false);

					this.follow(path);

					break;
				case COMMAND_ATTACK:
					var attackTarget:Unit = parameters[0] as Unit;

					trace("Unit Attack: ", this, attackTarget);
					if(!attackTarget) { trace("INVALID ATTACK TARGET"); }

					break;
			}

		}

		public override function toString():String {
			return "<Unit:" + owner + "; id=" + id + "; pos=" + x + "," + y + ">";
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

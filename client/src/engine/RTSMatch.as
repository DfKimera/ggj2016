package engine {
	import engine.Terrain;

	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;

	import org.flixel.FlxCamera;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;

	import org.flixel.FlxState;
	import org.flixel.FlxU;

	public class RTSMatch extends FlxState {

		public var terrain:Terrain;
		public var grid:Grid;
		public var unit:Unit;

		public var unitIndex:int = 1;

		public var $units:FlxGroup = new FlxGroup();
		public var $structures:FlxGroup = new FlxGroup();
		public var $ui:FlxGroup = new FlxGroup();

		public var selection:Selection = new Selection();

		private var cameraSpeed:int = 350;
		private var cameraDeadzoneOffset:int = 128;

		public var selectedUnits:Array = [];

		public override function create():void {
			FlxG.debug = true;
			FlxG.visualDebug = true;

			Audio.setup();

			terrain = new Terrain();
			grid = new Grid(terrain);

			setupUI();

			add(terrain);
			add($units);
			add($structures);
			add(grid);
			add($ui);

			setupCameraMovement();

		}

		public function setupUI():void {

			var spawnBtn:FlxButton = new FlxButton(15, 15, "Spawn unit", spawnUnit);
			$ui.add(spawnBtn);

		}

		public function setupCameraMovement():void {
			FlxG.resetCameras(new FlxCamera(0, 0, FlxG.width, FlxG.height));
			FlxG.worldBounds = new FlxRect(0, 0, terrain.x, terrain.y);

			FlxG.camera.setBounds(0, 0, terrain.width,terrain.height);

		}

		public override function update():void {

			super.update();

			handleCameraMovement();
			handleCollisions();
			handleUnitCommands();

		}


		public function handleCollisions():void {
			try {
				FlxG.collide($units, grid);
				FlxG.collide($units, $units);
			} catch (ex:Error) {}
		}

		public function handleCameraMovement():void {

			if (FlxG.keys.D || FlxG.keys.RIGHT || FlxG.mouse.screenX > FlxG.width - cameraDeadzoneOffset) {
				FlxG.camera.scroll.x += FlxG.elapsed * cameraSpeed;
			} else if (FlxG.keys.A || FlxG.keys.LEFT || FlxG.mouse.screenX < cameraDeadzoneOffset) {
				FlxG.camera.scroll.x -= FlxG.elapsed * cameraSpeed;
			}

			if (FlxG.keys.S || FlxG.keys.DOWN || FlxG.mouse.screenY > FlxG.height - cameraDeadzoneOffset) {
				FlxG.camera.scroll.y += FlxG.elapsed * cameraSpeed;
			} else if (FlxG.keys.W|| FlxG.keys.UP || FlxG.mouse.screenY < cameraDeadzoneOffset) {
				FlxG.camera.scroll.y -= FlxG.elapsed * cameraSpeed;
			}
		}

		public function handleUnitCommands():void {
			var target:FlxObject = new FlxObject(FlxG.mouse.x, FlxG.mouse.y,1,1);
			if(RightClick.hasJustPressed() && selection.hasUnitSelected()) {

				var hasTargetedStructure:Boolean = FlxG.overlap(target, $structures, function (pos:FlxObject, structure:Structure) {
					selection.commandSelected(Unit.COMMAND_ATTACK, [structure, target]);
				});

				if(hasTargetedStructure) return;

				var hasTargetedUnit:Boolean = FlxG.overlap(target, $units, function (pos:FlxObject, unit:Unit) {
					selection.commandSelected(Unit.COMMAND_ATTACK, [unit, target]);
				});

				if(hasTargetedUnit) return;

				selection.commandSelected(Unit.COMMAND_MOVE, [FlxG.mouse.getWorldPosition()]);

			}
		}

		public function spawnUnit():void {
			var x:Number = FlxU.getRandom([50, 120, 180, 240]) as Number;
			var y:Number = FlxU.getRandom([50, 120, 180, 240]) as Number;

			$units.add(new Unit(++unitIndex, 1, "peasant", x, y, grid, selection, $units));
		}

	}
}

package engine.states {

	import engine.gameplay.Level;
	import engine.gameplay.MultiplayerController;
	import engine.gameplay.Terrain;
	import engine.gameplay.Grid;
	import engine.gameplay.Selection;
	import engine.gameplay.Structure;
	import engine.gameplay.Unit;
	import engine.networking.MessageTypes;
	import engine.networking.NetworkedGameState;
	import engine.services.Audio;
	import engine.services.Log;
	import engine.services.RightClick;

	import org.flixel.FlxBasic;

	import org.flixel.FlxButton;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;

	import playerio.Client;
	import playerio.Message;

	public class RTSMatch extends NetworkedGameState {

		public var level:Level;
		public var terrain:Terrain;
		public var grid:Grid;

		public var $units:FlxGroup = new FlxGroup();
		public var $structures:FlxGroup = new FlxGroup();
		public var $props:FlxGroup = new FlxGroup();
		public var $ui:FlxGroup = new FlxGroup();

		public var selection:Selection = new Selection();
		public var multi:MultiplayerController;

		public var localTownCenter:Structure;
		public var localAltar:Structure;

		private var uiAnchor:FlxPoint = new FlxPoint(0,0);

		private var cameraHasFocused:Boolean = false;
		private var cameraSpeed:int = 350;
		private var cameraDeadzoneOffset:int = 128;

		public override function create():void {
			super.create();

			FlxG.debug = true;
			FlxG.visualDebug = true;

			Audio.setup();

			multi = new MultiplayerController(this, net);
		}

		public override function networkReady(client:Client):void {
			super.networkReady(client);

			net.whenServerNotice.add(onKicked);

			net.addMessageHandler(MessageTypes.CL_RESOURCE_UPDATE, multi.onResourceUpdate);
			net.addMessageHandler(MessageTypes.CL_UNIT_ATTACK, multi.onUnitAttack);
			net.addMessageHandler(MessageTypes.CL_UNIT_FOLLOW, multi.onUnitFollow);
			net.addMessageHandler(MessageTypes.CL_UNIT_DEATH, multi.onUnitDeath);
			net.addMessageHandler(MessageTypes.CL_UNIT_GATHER, multi.onUnitGather);
			net.addMessageHandler(MessageTypes.CL_UNIT_MOVE, multi.onUnitMove);

			net.addMessageHandler(MessageTypes.SV_CHAT_MESSAGE, multi.onChatMessage);
			net.addMessageHandler(MessageTypes.SV_UNIT_CREATE, multi.onUnitCreate);
			net.addMessageHandler(MessageTypes.SV_STRUCTURE_CREATE, multi.onStructureCreate);
			net.addMessageHandler(MessageTypes.SV_GAME_BEGIN, onGameBegin);

			net.sendMessage(MessageTypes.CL_READY);
		}

		public function onGameBegin(m:Message):void {
			level = new Level(this);
			terrain = level.terrain;
			grid = level.grid;

			setupUI();
			setupCameraMovement();

			add(terrain);
			add($props);
			add($structures);
			add($units);
			add(grid);
			add($ui);
		}

		public function onKicked(type:String, reason:String):void {
			Log.write("[matchmaking] Kicked: ", type, reason);
			FlxG.switchState(new Matchmaking);
		}

		public function setupUI():void {

			var spawnBtn:FlxButton = new FlxButton(50, 718, "Spawn unit", createUnit);

			addUI(spawnBtn);

		}

		public function createUnit():void {
			var x:Number = localTownCenter.getMidpoint().x;
			var y:Number = localTownCenter.getMidpoint().y + localTownCenter.height;

			multi.sendUnitSpawn("peasant", x, y);
		}

		public function addUI(element:FlxObject):void {
			element.scrollFactor = uiAnchor;
			$ui.add(element);
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

			if (FlxG.keys.D || FlxG.keys.RIGHT /*|| FlxG.mouse.screenX > FlxG.width - cameraDeadzoneOffset*/) {
				FlxG.camera.scroll.x += FlxG.elapsed * cameraSpeed;
			} else if (FlxG.keys.A || FlxG.keys.LEFT /*|| FlxG.mouse.screenX < cameraDeadzoneOffset*/) {
				FlxG.camera.scroll.x -= FlxG.elapsed * cameraSpeed;
			}

			if (FlxG.keys.S || FlxG.keys.DOWN /*|| FlxG.mouse.screenY > FlxG.height - cameraDeadzoneOffset*/) {
				FlxG.camera.scroll.y += FlxG.elapsed * cameraSpeed;
			} else if (FlxG.keys.W|| FlxG.keys.UP /*|| FlxG.mouse.screenY < cameraDeadzoneOffset*/) {
				FlxG.camera.scroll.y -= FlxG.elapsed * cameraSpeed;
			}
		}

		public function handleUnitCommands():void {
			var target:FlxObject = new FlxObject(FlxG.mouse.x, FlxG.mouse.y,1,1);

			if(!RightClick.hasJustPressed() || !selection.hasUnitSelected()) return;

			var hasTargetedStructure:Boolean = FlxG.overlap(target, $structures, function (pos:FlxObject, structure:Structure):void {
				selection.commandSelected(Unit.COMMAND_ATTACK, [structure, target]);
			});

			if(hasTargetedStructure) return;

			var hasTargetedUnit:Boolean = FlxG.overlap(target, $units, function (pos:FlxObject, unit:Unit):void {
				selection.commandSelected(Unit.COMMAND_ATTACK, [unit, target]);
			});

			if(hasTargetedUnit) return;

			selection.commandSelected(Unit.COMMAND_MOVE, [FlxG.mouse.x, FlxG.mouse.y]);
		}

		public function spawnUnit(entityID:int, ownerID:int, type:String, x:Number, y:Number):void {
			Log.write("[server] Spawning unit: ", entityID, ownerID, type, x, y);
			$units.add(new Unit(entityID, ownerID, type, x, y, this));
		}

		public function spawnStructure(entityID:int, ownerID:int, type:String, x:Number, y:Number):void {
			Log.write("[server] Spawning structure: ", entityID, ownerID, type, x, y);

			var structure:Structure = new Structure(entityID, ownerID, type, x, y, this);

			$structures.add(structure);

			if(type == "structure_town_center" && ownerID == net.localPlayerID) {
				localTownCenter = structure;

				if(!cameraHasFocused) {
					trace("[local] Got player's town center! Focusing camera...");
					FlxG.camera.focusOn(new FlxPoint(x, y));
					cameraHasFocused = true;
				}

			} else if(type == "structure_altar" && ownerID == net.localPlayerID) {
				localAltar = structure;
			}
		}

		public function spawnProp(prop:FlxSprite):void {
			$props.add(prop);
		}

	}
}

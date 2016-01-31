package engine.gameplay {
	import engine.interfaces.Damageable;
	import engine.interfaces.Targetable;
	import engine.networking.MessageTypes;
	import engine.networking.Networking;
	import engine.services.Log;
	import engine.states.RTSMatch;

	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;

	import playerio.Message;

	public class MultiplayerController {

		public var game:RTSMatch;
		public var net:Networking;

		public function MultiplayerController(game:RTSMatch, net:Networking) {
			this.game = game;
			this.net = net;
		}

		public function sendUnitFollow(unit:Unit, path:FlxPath):void {

			Log.write("[net.local.send] Unit follow: ", unit, path);

			var nodes:Array = [];

			if(!path) {
				Log.write("[net.local.send.ERROR] Can't follow invalid path: ", path);
				return;
			}

			if(path.nodes.length <= 0) {
				Log.write("[net.local.send.ERROR] Can't follow empty path: ", path);
				return;
			}

			for (var i in path.nodes) {
				if(!path.nodes.hasOwnProperty(i)) continue;

				var node:FlxPoint = path.nodes[i] as FlxPoint;
				nodes.push(int(node.x) + "," + int(node.y));

			}

			net.sendMessage(MessageTypes.CL_UNIT_FOLLOW, unit.id, nodes.join(";"));
		}

		public function sendUnitAttack(unit:Unit, target:Targetable, damage:int):void {
			Log.write("[net.local.send] Unit attack: ", unit, target, damage);
			net.sendMessage(MessageTypes.CL_UNIT_ATTACK, unit.id, target.getID(), damage);
		}

		public function sendUnitSpawn(type:String, x:Number, y:Number):void {
			Log.write("[net.local.send] Unit spawn: ", type, x, y);
			net.sendMessage(MessageTypes.CL_UNIT_CREATE, type, x, y);
		}

		public function sendStructureSpawn(type:String, x:Number, y:Number):void {
			Log.write("[net.local.send] Structure spawn: ", type, x, y);
			net.sendMessage(MessageTypes.CL_STRUCTURE_CREATE, type, x, y);
		}

		// -------------------------------------------------------------------------------------------------------------

		public function onChatMessage(m:Message):void {

		}

		public function onResourceUpdate(m:Message):void {

		}

		public function onUnitFollow(m:Message):void {
			var entityID:int = m.getInt(0);
			var nodeList:String = m.getString(1);

			var entity:Entity = Entity.getByID(entityID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to execute command on invalid entity: ", entityID);
			if(!(entity is Unit)) return Log.write("[multiplayer.ERROR] Cannot trigger FOLLOW on a structure", entityID);

			var path:FlxPath = new FlxPath();
			var nodes:Array = nodeList.split(";");

			for each(var node:String in nodes) {
				var n:Array = node.split(",");
				path.add(Number(n[0]), Number(n[1]));
			}

			(entity as Unit).currentTask = Unit.TASK_MOVE;
			(entity as Unit).follow(path);
		}

		public function onUnitAttack(m:Message):void {
			var entityID:int = m.getInt(0);
			var targetID:int = m.getInt(1);
			var damage:int = m.getInt(2);

			var entity:Entity = Entity.getByID(entityID);
			var target:Entity = Entity.getByID(targetID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to request attack to an invalid entity: ", entityID);
			if(!target || !(target is Entity)) return Log.write("[multiplayer.ERROR] Attempted to target attack on an invalid entity: ", targetID);

			entity.onAttack(target, damage);
		}

		public function onUnitCreate(m:Message):void {
			var entityID:int = m.getInt(0);
			var ownerID:int = m.getInt(1);
			var type:String = m.getString(2);
			var x:Number = m.getNumber(3);
			var y:Number = m.getNumber(4);

			game.spawnUnit(entityID, ownerID, type, x, y);
		}

		public function onUnitDeath(m:Message):void {
			var entityID:int = m.getInt(0);

			var entity:Entity = Entity.getByID(entityID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to kill invalid entity: ", entityID);

			entity.onDeath();
		}

		public function onUnitGather(m:Message):void {

		}

		public function onUnitMove(m:Message):void {
			var unitID:int = m.getInt(0);
			var targetX:Number = m.getNumber(1);
			var targetY:Number = m.getNumber(2);

			var entity:Entity = Entity.getByID(unitID);

			if(!entity) return Log.write("[multiplayer.ERROR] Cannot move invalid entity: ", unitID);

			entity.x = targetX;
			entity.y = targetY;
		}

		public function onStructureCreate(m:Message):void {
			var entityID:int = m.getInt(0);
			var ownerID:int = m.getInt(1);
			var type:String = m.getString(2);
			var x:Number = m.getNumber(3);
			var y:Number = m.getNumber(4);

			game.spawnStructure(entityID, ownerID, type, x, y);
		}
	}
}

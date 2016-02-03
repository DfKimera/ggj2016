package engine.gameplay {

	import engine.interfaces.Targetable;

	import engine.networking.MessageTypes;
	import engine.networking.Networking;

	import engine.services.Log;
	import engine.services.Utils;
	import engine.states.RTSMatch;

	import org.flixel.FlxPath;

	import playerio.Message;

	public class MultiplayerController {

		public var game:RTSMatch;
		public var net:Networking;

		public function MultiplayerController(game:RTSMatch, net:Networking) {
			this.game = game;
			this.net = net;
		}

		public function sendUnitActionFollowPath(unit:Unit, path:FlxPath):void {

			Log.write("[net.local.send] Unit -> ACTION_FOLLOW_PATH: ", unit, path);

			var nodeList:String = Utils.serializePath(path);

			if(!path) return Log.write("[net.local.send.ERROR] Can't follow invalid path: ", path);
			if(path.nodes.length <= 0) return Log.write("[net.local.send.ERROR] Can't follow empty path: ", path);

			net.sendMessage(MessageTypes.CL_UNIT_ACTION_FOLLOW_PATH, unit.id, nodeList);
		}

		public function sendUnitActionHit(unit:Unit, target:Targetable, damage:int):void {
			Log.write("[net.local.send] Unit -> ACTION_HIT: ", unit, target, damage);
			net.sendMessage(MessageTypes.CL_UNIT_ACTION_HIT, unit.id, target.getID(), damage);
		}

		public function sendUnitActionStop(unit:Unit):void {
			Log.write("[net.local.send] Unit -> ACTION_STOP: ", unit);
			net.sendMessage(MessageTypes.CL_UNIT_ACTION_STOP, unit.id, unit.x, unit.y);
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

		// -------------------------------------------------------------------------------------------------------------
		// Entity spawn/destroy handlers
		// -------------------------------------------------------------------------------------------------------------

		public function onUnitCreate(m:Message):void {
			var entityID:int = m.getInt(0);
			var ownerID:int = m.getInt(1);
			var type:String = m.getString(2);
			var x:Number = m.getNumber(3);
			var y:Number = m.getNumber(4);

			game.spawnUnit(entityID, ownerID, type, x, y);
		}

		public function onStructureCreate(m:Message):void {
			var entityID:int = m.getInt(0);
			var ownerID:int = m.getInt(1);
			var type:String = m.getString(2);
			var x:Number = m.getNumber(3);
			var y:Number = m.getNumber(4);

			game.spawnStructure(entityID, ownerID, type, x, y);
		}

		public function onEntityDeath(m:Message):void {
			var entityID:int = m.getInt(0);

			var entity:Entity = Entity.getByID(entityID);

			if (!entity) return Log.write("[multiplayer.ERROR] Attempted to kill invalid entity: ",entityID);

			entity.onDeath();
		}

		// --------------------------------------------------------------------------------------------------------
		// Entity action handlers
		// --------------------------------------------------------------------------------------------------------

		public function onUnitActionFollowPath(m:Message):void {
			var entityID:int = m.getInt(0);
			var nodeList:String = m.getString(1);

			var entity:Entity = Entity.getByID(entityID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to execute command on invalid entity: ", entityID);

			var path:FlxPath = Utils.deserializePath(nodeList);

			(entity as Unit).actionFollowPath(path);
		}

		public function onUnitActionHit(m:Message):void {
			var entityID:int = m.getInt(0);
			var targetID:int = m.getInt(1);
			var damage:int = m.getInt(2);

			var entity:Entity = Entity.getByID(entityID);
			var target:Entity = Entity.getByID(targetID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to request attack to an invalid entity: ", entityID);
			if(!target) return Log.write("[multiplayer.ERROR] Attempted to target attack on an invalid entity: ", targetID);

			(entity as Unit).actionHit(target, damage);
		}

		public function onUnitActionStop(m:Message):void {
			var entityID:int = m.getInt(0);
			var stopX:int = m.getInt(1);
			var stopY:int = m.getInt(2);

			var entity:Entity = Entity.getByID(entityID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to request attack to an invalid entity: ", entityID);

			(entity as Unit).actionStop(stopX, stopY);
		}

		public function onUnitActionGather(m:Message):void {
			var entityID:int = m.getInt(0);
			var targetID:int = m.getInt(1);

			var entity:Entity = Entity.getByID(entityID);
			var target:Entity = Entity.getByID(targetID);

			if(!entity) return Log.write("[multiplayer.ERROR] Attempted to request gather to an invalid entity: ", entityID);
			if(!target) return Log.write("[multiplayer.ERROR] Attempted to target gather on an invalid entity: ", targetID);

			(entity as Unit).actionGather(target);
		}
	}
}

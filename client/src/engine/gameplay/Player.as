package engine.gameplay {
	import engine.services.Log;

	public class Player {

		protected static var _playersByID:Array = [];

		public var id:int;
		public var nickname:String;
		public var isLocal:Boolean;
		public var isHost:Boolean;

		public function Player(id:int, nickname:String, isLocal:Boolean, isHost:Boolean):void {
			this.id = id;
			this.nickname = nickname;
			this.isLocal = isLocal;
			this.isHost = isHost;

			register(this);
		}

		public static function register(player:Player):void {
			Log.write("[players] Registered player: ", player.id, player.nickname);
			_playersByID[player.id] = player;
		}

		public static function unregister(id:int):void {
			Log.write("[players] Unregistered player: ", id);
			_playersByID[id] = null;
		}

		public static function getByID(id:int):Player {
			return _playersByID[id];
		}

		public static function getNames():Array {

			Log.write("[players] Get names: ", _playersByID);

			var names:Array = [];

			for each(var p:Player in _playersByID) {
				names.push(p.nickname);
			}

			return names;
		}

	}
}

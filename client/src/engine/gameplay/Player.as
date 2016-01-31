package engine.gameplay {
	public class Player {

		protected static var _playersByID:Array = [];

		public var id:int;
		public var nickname:String;
		public var isLocal:Boolean;

		public function Player(id:int, nickname:String, isLocal:Boolean):void {
			this.id = id;
			this.nickname = nickname;
			this.isLocal = isLocal;

			register(this);
		}

		public static function register(player:Player):void {
			trace("[players] Registered player: ", player.id, player.nickname);
			_playersByID[player.id] = player;
		}

		public static function unregister(id:int):void {
			trace("[players] Unregistered player: ", id);
			_playersByID[id] = null;
		}

		public static function getByID(id:int):Player {
			return _playersByID[id];
		}

		public static function getNames():Array {

			trace("[players] Get names: ", _playersByID);

			var names:Array = [];

			for each(var p:Player in _playersByID) {
				names.push(p.nickname);
			}

			return names;
		}

	}
}

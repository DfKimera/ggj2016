package engine.networking {

	import engine.gameplay.Player;
	import engine.services.Log;

	import flash.events.EventDispatcher;

	import game.Config;

	import org.flixel.FlxG;
	import org.osflash.signals.Signal;

	import playerio.Client;

	import playerio.Connection;
	import playerio.Message;
	import playerio.Multiplayer;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;

	public class Networking extends EventDispatcher {

		public var conn:Connection;
		public var client:Client;
		public var multi:Multiplayer;

		public var isConnected:Boolean = false;
		public var isInRoom:Boolean = false;
		public var isPlaying:Boolean = false;

		public var localPlayerID:int = 0;
		public var hostPlayerID:int = 0;
		public var nickname:String = "Guest_" + String(int(FlxG.random() * 10000));

		public var whenError:Signal = new Signal();
		public var whenReady:Signal = new Signal();
		public var whenConnected:Signal = new Signal();
		public var whenHostedRoom:Signal = new Signal();
		public var whenJoinedRoom:Signal = new Signal();
		public var whenDisconnected:Signal = new Signal();
		public var whenServerNotice:Signal = new Signal();

		private static var instance:Networking;

		public function Networking() {
			Log.write("[playerio] Connecting to server, gameID=", Config.GAME_ID);
			PlayerIO.connect(
					Bootstrap.instance.stage,
					Config.GAME_ID,
					Config.CONN_ID,
					String("User_" + FlxG.random() * 100000),
					"",
					"",
					onConnect,
					onError
			);
		}

		public static function getInstance():Networking {
			if(!instance) instance = new Networking();
			return instance;
		}

		private function onConnect(client:Client):void {
			this.client = client;
			this.multi = client.multiplayer;

			if(Config.DEVELOPER_MODE) {
				multi.developmentServer = Config.DEVELOPER_IP;
			}

			Log.write("[playerio] Connected! userID=", client.connectUserId, (Config.DEVELOPER_MODE) ? "developerMode=yes, host=" + Config.DEVELOPER_IP : "developerMode=no");

			this.isConnected = true;
			this.whenConnected.dispatch(client);
		}

		private function onError(error:PlayerIOError):void {
			Log.write("[playerio.ERROR] ", error);
			whenError.dispatch(error);
		}

		public function setNickname(nickname:String):void {
			this.nickname = nickname;
		}

		public function getRooms(closure:Function):void {
			Log.write("[playerio] Getting room list...");
			multi.listRooms("RTSMatch", "", 64, 0, closure, onError);
		}

		public function createRoom(roomID:String):void {
			Log.write("[playerio] Creating room: ", roomID);
			multi.createJoinRoom(roomID, "RTSMatch", true, null, {nickname: this.nickname}, onRoomCreated, onError);
		}

		private function onRoomCreated(conn:Connection):void {
			this.isInRoom = true;
			this.conn = conn;

			Log.write("[playerio] Room created: ", conn.roomId);

			setupListeners();

			this.whenHostedRoom.dispatch(conn);
			this.whenReady.dispatch(conn);
		}

		public function joinRoom(roomID:String):void {
			Log.write("[playerio] Joining room: ", roomID);
			multi.joinRoom(roomID, {nickname: this.nickname}, onRoomJoined, onError);
		}

		private function onRoomJoined(conn:Connection):void {
			this.isInRoom = true;
			this.conn = conn;

			Log.write("[playerio] Room joined: ", conn.roomId);

			setupListeners();

			this.whenJoinedRoom.dispatch(conn);
			this.whenReady.dispatch(conn);
		}

		private function onServerNotice(m:Message):void {
			this.whenServerNotice.dispatch(m.getString(0), m.getString(1));
		}

		public function setupListeners():void {
			conn.addDisconnectHandler(onDisconnect);

			conn.addMessageHandler(MessageTypes.SV_NOTICE, onServerNotice);
			conn.addMessageHandler(MessageTypes.SV_PLAYER_REGISTER, onPlayerRegister);
			conn.addMessageHandler(MessageTypes.SV_PLAYER_UNREGISTER, onPlayerUnregister);
		}

		public function addMessageHandler(messageType:String, closure:Function):void {
			conn.addMessageHandler(messageType, closure);
		}

		public function sendMessage(... args):void {
			conn.send.apply(conn, args)
		}

		private function onDisconnect():void {
			isConnected = false;
			isInRoom = false;
			isPlaying = false;

			Log.write("[playerio] Disconnected!");

			this.whenDisconnected.dispatch();
		}

		public function onPlayerRegister(m:Message):void {
			var player:Player = new Player(m.getInt(0), m.getString(1), m.getBoolean(2), m.getBoolean(3));

			if(player.isLocal) {
				localPlayerID = player.id;
			}

			if(player.isHost) {
				hostPlayerID = player.id;
			}
		}

		public function onPlayerUnregister(m:Message):void {
			Player.unregister(m.getInt(0));
		}
	}
}

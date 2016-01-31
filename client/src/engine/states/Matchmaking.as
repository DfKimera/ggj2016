package engine.states {

	import engine.networking.NetworkedGameState;
	import engine.services.Log;
	import engine.ui.UITextInput;

	import game.Config;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;

	import playerio.Client;
	import playerio.Connection;

	import playerio.RoomInfo;

	public class Matchmaking extends NetworkedGameState {

		public var titleLbl:FlxText;
		public var roomListLbl:FlxText;
		public var nicknameLbl:FlxText;
		public var newRoomLbl:FlxText;

		public var createRoomBtn:FlxButtonPlus;
		public var refreshBtn:FlxButtonPlus;
		public var nicknameInput:UITextInput;

		public var $rooms:FlxGroup = new FlxGroup();

		public override function create():void {
			super.create();

			titleLbl = new FlxText(0, 50, 1024, "GGJ16 - Ritual");
			titleLbl.color = 0xFFFFFF;
			titleLbl.size = 24;
			titleLbl.alignment = "center";

			nicknameLbl = new FlxText(50, 70, 200, "Nickname:");
			nicknameLbl.color = 0xFFFFF;
			nicknameLbl.size = 14;

			nicknameInput = new UITextInput(50, 100, 200, 30, "Guest", Config.DEFAULT_TEXT_FORMAT, onNicknameChange);
			nicknameInput.active = false;

			newRoomLbl = new FlxText(800, 70, 500, "Create new room:");
			newRoomLbl.color = 0xFFFFF;
			newRoomLbl.size = 14;

			createRoomBtn = new UITextInput(800, 100, 200, 30, "Just another game room", Config.DEFAULT_TEXT_FORMAT, onRoomOpen);
			createRoomBtn.active = false;

			refreshBtn = new FlxButtonPlus(350, 150, refreshRooms, null, "Refresh", 150, 30);
			refreshBtn.active = false;

			roomListLbl = new FlxText(50, 150, 500, "Game rooms:");
			roomListLbl.color = 0xFFFFF;
			roomListLbl.size = 14;

			add(titleLbl);
			add(roomListLbl);
			add(nicknameLbl);
			add(newRoomLbl);
			add(nicknameInput);
			add(createRoomBtn);
			add(refreshBtn);

			add($rooms);
		}

		public override function networkReady(client:Client):void {
			super.networkReady(client);

			nicknameInput.active = true;
			createRoomBtn.active = true;
			refreshBtn.active = true;

			net.whenReady.add(onRoomEnter);
			refreshRooms();
		}

		public function refreshRooms():void {
			net.getRooms(renderRoomList);
		}

		public function renderRoomList(rooms:Array):void {

			Log.write("[matchmaking] List refreshed, ", rooms.length, " rooms available");

			$rooms.clear();

			for (var i:String in rooms) {
				if(!rooms.hasOwnProperty(i)) continue;
				var room:RoomInfo = rooms[i];

				$rooms.add(new FlxButtonPlus(50, 200 + (int(i) * 30), onRoomClick, [room.id], "Match -  " + room.id, 400, 28));
			}

		}

		public function onNicknameChange(nickname:String):void {
			net.setNickname(nickname);
		}

		public function onRoomClick(roomID:String):void {
			Log.write("[matchmaking] Joining room: ", roomID);
			net.joinRoom(roomID);
		}

		public function onRoomOpen(name:String):void {
			createRoomBtn.visible = false;

			var randomID:String = String(int(FlxG.random() * 10000));

			net.createRoom(name + " - #" + randomID);

			refreshRooms();
		}

		public function onRoomEnter(conn:Connection):void {
			FlxG.switchState(new Lobby);
		}

	}
}

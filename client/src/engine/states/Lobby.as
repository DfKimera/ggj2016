package engine.states {

	import engine.gameplay.Player;
	import engine.networking.MessageTypes;
	import engine.networking.NetworkedGameState;
	import engine.services.Log;
	import engine.ui.UITextInput;

	import game.Config;

	import org.flixel.FlxG;

	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;

	import playerio.Client;
	import playerio.Message;

	public class Lobby extends NetworkedGameState {

		public var lobbyLbl:FlxText;
		public var chatText:FlxText;
		public var chatInput:UITextInput;

		public var startGameBtn:FlxButtonPlus;

		public function Lobby() {
			super();

			lobbyLbl = new FlxText(50, 50, 500, "Lobby - " + net.conn.roomId);
			lobbyLbl.color = 0xFFFFFF;
			lobbyLbl.size = 24;

			chatText = new FlxText(50, 100, 500, "");
			chatText.color = 0xEEEEEE;
			chatText.size = 14;
			chatText.height = 500;

			chatInput = new UITextInput(50, 700, 500, 30, "", Config.DEFAULT_TEXT_FORMAT, onChatEnter);
			startGameBtn = new FlxButtonPlus(600, 700, onReady, null, "I'm ready", 150, 30);
		}

		public override function create():void {
			super.create();

			FlxG.debug = true;
			FlxG.visualDebug = false;

			add(lobbyLbl);
			add(chatText);
			add(chatInput);
			add(startGameBtn);
		}

		public override function networkReady(client:Client):void {
			super.networkReady(client);

			net.whenServerNotice.add(onKicked);

			net.addMessageHandler(MessageTypes.SV_PLAYER_JOINED, onPlayerJoined);
			net.addMessageHandler(MessageTypes.SV_PLAYER_LEFT, onPlayerLeft);
			net.addMessageHandler(MessageTypes.SV_LOBBY_READY, onPlayerReady);
			net.addMessageHandler(MessageTypes.SV_CHAT_MESSAGE, onChatMessage);
			net.addMessageHandler(MessageTypes.SV_GAME_START, onGameStart);
		}

		public function onChatEnter(message:String):void {
			net.sendMessage(MessageTypes.CL_CHAT_MESSAGE, message);
			chatInput.clearText();
		}

		public function onPlayerJoined(m:Message):void {
			printChat("[!!]", "SYSTEM", m.getString(1) + " has joined the lobby");
		}

		public function onPlayerLeft(m:Message):void {
			printChat("[!!]", "SYSTEM", m.getString(1) + " has left the lobby");
		}

		public function onPlayerReady(m:Message):void {
			printChat("[!!]", "SYSTEM", m.getString(1) + " is ready to play!");
		}

		public function onChatMessage(m:Message):void {
			printChat(m.getString(0), m.getString(1), m.getString(2));
		}

		public function onKicked(type:String, reason:String):void {
			Log.write("[matchmaking] Kicked: ", type, reason);
			FlxG.switchState(new Matchmaking);
		}

		public function printChat(timestamp:String, author:String, message:String):void {
			var text:String = "\n" + timestamp + " <" + author + "> " + message;

			Log.write(text);

			if(chatText) chatText.text += text;
		}

		public function onReady():void {
			net.sendMessage(MessageTypes.CL_LOBBY_READY);
			startGameBtn.visible = false;
		}

		public function onGameStart(m:Message):void {
			Log.write("[matchmaking] Game is starting! localPlayerID: ", net.localPlayerID, "; players: ", Player.getNames().join(", "));

			FlxG.switchState(new RTSMatch);
		}

	}
}

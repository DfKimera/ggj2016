using System;
using PlayerIO.GameLibrary;


namespace GGJ2016 {

	public class RTSLobby : IMultiplayerController {

		public RoomInstance room;
		public int readyPlayers = 0;

		public RTSLobby(RoomInstance room) {
			Console.WriteLine("[ RTS LOBBY ]");
			this.room = room;
		}

		public void onPlayerJoined(Player player) {
			if(room.numPlayers >= RoomInstance.MAX_PLAYERS) {
				player.kick("max_players");
				return;
			}
			
			player.nickname = player.JoinData["nickname"];

			if(player.nickname.ToUpper() == "SYSTEM") {
				player.kick("nickname_not_allowed");
				return;
			}

			room.numPlayers++;
			
			Console.WriteLine("Player joined: " + player.nickname);
			
			room.Broadcast(MessageTypes.SV_PLAYER_JOINED, player.Id, player.nickname);

			foreach(Player p in room.Players) {
				player.Send(MessageTypes.SV_PLAYER_REGISTER, p.Id, p.nickname, (player.Id == p.Id));
			}
		}

		public void onPlayerLeft(Player player) {
			Console.WriteLine("Player left: " + player.nickname);
			
			if(player.isReady) readyPlayers--;
			room.numPlayers--;
			
			room.Broadcast(MessageTypes.SV_PLAYER_LEFT, player.Id, player.nickname);
			room.Broadcast(MessageTypes.SV_PLAYER_UNREGISTER, player.Id);
		}

		public void handleMessage(Player player, Message message) {
			switch(message.Type) {
				case MessageTypes.CL_CHAT_MESSAGE: 
					onChatMessage(player, message); 
					break;
				case MessageTypes.CL_LOBBY_READY: 
					onLobbyReady(player); 
					break;
			}
		}

		public void onChatMessage(Player player, Message message) {
			Message m = Message.Create(MessageTypes.SV_CHAT_MESSAGE, "", player.nickname, message.GetString(0));
			room.Broadcast(m);
		}
		
		public void onLobbyReady(Player player) {
			player.isReady = true;
			readyPlayers++;

			Console.WriteLine("Player is ready: " + player.nickname);

			room.Broadcast(MessageTypes.SV_LOBBY_READY, player.Id, player.nickname);
			
			if(readyPlayers == RoomInstance.MIN_PLAYERS) {
				Console.WriteLine("All players ready, starting game...");
				room.startGame();
			}
		}

	}
}


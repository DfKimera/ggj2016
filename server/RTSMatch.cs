using System;
using PlayerIO.GameLibrary;


namespace GGJ2016 {

	public class RTSMatch : IMultiplayerController {
		public RoomInstance room;
		public int entityIndex = 0;
		
		public RTSMatch(RoomInstance room) {
			Console.WriteLine("[ RTS MATCH ]");
			this.room = room;
		}
		
		public void onPlayerJoined(Player player) {
			player.kick("in_progress");
		}
		
		public void onPlayerLeft(Player player) {
			foreach(Player p in room.Players) {
				p.kick("match_forfeited");
			}
		}
		
		public void handleMessage(Player player, Message message) {
			switch(message.Type) {
				case MessageTypes.CL_CHAT_MESSAGE:
					onChatMessage(player, message); 
					break;
				case MessageTypes.CL_UNIT_CREATE:
					onUnitCreate(player, message);
					break;

				default:
					Console.WriteLine("[<< : " + message.Type + "] <" + player.nickname + "> " + message.ToString());
					room.Broadcast(message);
					break;
			}
		}

		public void onChatMessage(Player player, Message message) {
			Message m = Message.Create(MessageTypes.SV_CHAT_MESSAGE, "", player.nickname, message.GetString(0));
			room.Broadcast(m);
		}

		public void onUnitCreate(Player player, Message message) {
			int entityID = ++entityIndex;
			int ownerID = player.Id;
			String type = message.GetString(0);
			double x = message.GetDouble(1);
			double y = message.GetDouble(2);

			room.Broadcast(MessageTypes.SV_UNIT_CREATE, entityID, ownerID, type, x, y);

		}
	}
}


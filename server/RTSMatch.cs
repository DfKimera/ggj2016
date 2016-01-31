using System;
using PlayerIO.GameLibrary;


namespace GGJ2016 {

	public class RTSMatch : IMultiplayerController {
		public RoomInstance room;
		public int entityIndex = 0;

		public int numReady = 0;
		
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
				case MessageTypes.CL_READY:
					onPlayerReady(player, message);
					break;
				case MessageTypes.CL_CHAT_MESSAGE:
					onChatMessage(player, message); 
					break;
				case MessageTypes.CL_UNIT_CREATE:
					onUnitCreate(player, message);
					break;
				case MessageTypes.CL_STRUCTURE_CREATE:
					onStructureCreate(player, message);
					break;

				default:
					Console.WriteLine("[<< : " + message.Type + "] <" + player.nickname + "> " + message.ToString());
					room.Broadcast(message);
					break;
			}
		}

		public void onPlayerReady(Player player, Message message) {
			numReady++;

			Console.WriteLine(player + " is ready to receive, count=" + numReady);

			if(numReady >= 2) { // this is to ensure all clients are ready to begin receiving messages
				Console.WriteLine("-- BEGIN SIMULATION --");
				room.Broadcast(MessageTypes.SV_GAME_BEGIN);
			}
		}

		public void onChatMessage(Player player, Message message) {
			Console.WriteLine("[CHAT] " + player + ": " + message.GetString(0));
			Message m = Message.Create(MessageTypes.SV_CHAT_MESSAGE, "", player.nickname, message.GetString(0));
			room.Broadcast(m);
		}

		public void onUnitCreate(Player player, Message message) {
			int entityID = ++entityIndex;
			int ownerID = player.Id;
			String type = message.GetString(0);
			double x = message.GetDouble(1);
			double y = message.GetDouble(2);

			Console.WriteLine("[ENGINE] " + player + ": create Unit - id=" + entityID + ", owner=" + ownerID + ", type=" + type + ", pos=" + x + "," + y);

			room.Broadcast(MessageTypes.SV_UNIT_CREATE, entityID, ownerID, type, x, y);

		}

		public void onStructureCreate(Player player, Message message) {
			int entityID = ++entityIndex;
			int ownerID = player.Id;

			String type = message.GetString(0);
			double x = message.GetDouble(1);
			double y = message.GetDouble(2);

			switch(type) {
				case "structure_town_center":

					// Gives ownership of this town center to the first player without one
					foreach(Player p in room.Players) {
						if(p.townCenterID == 0) {
							Console.WriteLine("[GAMEPLAY] Giving TOWN CENTER eid=" + entityID + " to " + player);
							p.townCenterID = entityID;
							ownerID = p.Id;
							break;
						}
					}

					break;

				case "structure_altar":

					// Gives ownership of this altar to the first player without one
					foreach(Player p in room.Players) {
						if(p.altarID == 0) {
							Console.WriteLine("[GAMEPLAY] Giving ALTAR eid=" + entityID + " to " + player);
							p.altarID = entityID;
							ownerID = p.Id;
							break;
						}
					}

					break;
			}

			Console.WriteLine("[ENGINE] " + player + ": create Structure - id=" + entityID + ", owner=" + ownerID + ", type=" + type + ", pos=" + x + "," + y);
			
			room.Broadcast(MessageTypes.SV_STRUCTURE_CREATE, entityID, ownerID, type, x, y);
			
		}
	}
}


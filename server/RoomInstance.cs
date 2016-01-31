using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;
using System.Globalization;

namespace GGJ2016 {

	[RoomType("RTSMatch")]
	public class RoomInstance : Game<Player> {

		public const int STATUS_LOBBY = 1;
		public const int STATUS_MATCH = 2;

		public const int MIN_PLAYERS = 2;
		public const int MAX_PLAYERS = 2;

		public int matchStatus = STATUS_LOBBY;
		public int numPlayers = 0;

		public int hostPlayerID = 0;

		public IMultiplayerController controller;

		public override void GameStarted() {
			controller = new RTSLobby(this);
			Console.WriteLine("Room open: " + RoomId);
		}
		
		public override void GameClosed() {
			Console.WriteLine("Room closed: " + RoomId);
		}
		
		public override void UserJoined(Player player) {
			if(hostPlayerID == 0) {
				hostPlayerID = player.Id;
				player.isHost = true;
			}

			controller.onPlayerJoined(player);
		}
		
		public override void UserLeft(Player player) {
			if(player.isHost) {
				hostPlayerID = 0;
			}

			controller.onPlayerLeft(player);
		}
		
		public override void GotMessage(Player player, Message message) {
			controller.handleMessage(player, message);
		}

		public void startGame() {
			matchStatus = STATUS_MATCH;

			controller = new RTSMatch(this);

			foreach(Player p in Players) {
				p.Send(MessageTypes.SV_GAME_START, p.Id);
			}
		}
	}
}

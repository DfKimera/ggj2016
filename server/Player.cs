using System;
using PlayerIO.GameLibrary;

namespace GGJ2016 {

	public class Player : BasePlayer {
		public string nickname = "Guest";
		public bool isReady = false;

		public void kick(String reason) {
			Send(MessageTypes.SV_NOTICE, "kicked", "max_players");
			Disconnect();
		}

	}

}
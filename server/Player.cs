using System;
using PlayerIO.GameLibrary;

namespace GGJ2016 {

	public class Player : BasePlayer {
		public string nickname = "Guest";
		public bool isReady = false;
		public bool isHost = false;

		public int townCenterID = 0;
		public int altarID = 0;

		public void kick(String reason) {
			Send(MessageTypes.SV_NOTICE, "kicked", "max_players");
			Disconnect();
		}

		public String toString() {
			return "<Player:" + this.Id + ":\"" + this.nickname + "\">";
		}

	}

}
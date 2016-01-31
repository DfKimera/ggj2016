using System;
using PlayerIO.GameLibrary;


namespace GGJ2016 {

	public interface IMultiplayerController {
	
		void onPlayerJoined(Player player);
		void onPlayerLeft(Player player);
		void handleMessage(Player player, Message message);

	}
}


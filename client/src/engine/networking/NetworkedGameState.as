package engine.networking {
	import engine.gameplay.Player;
	import engine.services.Log;

	import flash.utils.setTimeout;

	import org.flixel.FlxState;

	import playerio.Client;
	import playerio.Message;

	public class NetworkedGameState extends FlxState {

		public static var net:Networking;

		public override function create():void {
			super.create();

			Log.write("[networking] New state: ", this);
			Log.write("[networking] Registering networking service...");

			net = Networking.getInstance();
			net.whenConnected.add(this.networkReady);

			Log.write("[networking] Waiting for ready signal");

			if(net.isConnected) {
				Log.write("[networking] Service was previously initialized, dispatching ready signal");
				setTimeout(networkReady, 0, net.client);
			}
		}

		public function getLocalPlayerID():int {
			return net.localPlayerID;
		}

		public function getLocalPlayer():Player {
			return Player.getByID(net.localPlayerID);
		}

		public function getHostPlayerID():int {
			return net.hostPlayerID;
		}

		public function getHostPlayer():Player {
			return Player.getByID(net.hostPlayerID);
		}

		public function networkReady(client:Client):void {
			Log.write("[networking] Network is ready!", client);
		}
	}
}

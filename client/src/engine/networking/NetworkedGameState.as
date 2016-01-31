package engine.networking {
	import engine.gameplay.Player;

	import flash.utils.setTimeout;

	import org.flixel.FlxState;

	import playerio.Client;
	import playerio.Message;

	public class NetworkedGameState extends FlxState {

		public static var net:Networking;

		public override function create():void {
			super.create();

			trace("[networking] Registering networking service...");

			net = Networking.getInstance();
			net.whenConnected.add(this.networkReady);

			trace("[networking] Waiting for ready signal");

			if(net.isConnected) {
				trace("[networking] Service was previously initialized, dispatching ready signal");
				setTimeout(networkReady, 0, net.client);
			}
		}

		public function getLocalPlayerID():int {
			return net.localPlayerID;
		}

		public function getLocalPlayer():Player {
			return Player.getByID(net.localPlayerID);
		}

		public function networkReady(client:Client):void { }
	}
}
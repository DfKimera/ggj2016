package engine.networking {
	import game.Config;

	public class MessageTypes {

		// -----------------------------------------------------------------------------------------------------------
		// Client-server and P2P messages
		// -----------------------------------------------------------------------------------------------------------

		public static const CL_UNIT_CREATE:String = (Config.MESSAGE_TYPE_COMPACT) ? "cuc" : "CL_UNIT_CREATE";
		public static const CL_STRUCTURE_CREATE:String = (Config.MESSAGE_TYPE_COMPACT) ? "csc" : "CL_STRUCTURE_CREATE";

		public static const CL_UNIT_ACTION_FOLLOW_PATH:String = (Config.MESSAGE_TYPE_COMPACT) ? "cuf" : "CL_UNIT_ACTION_FOLLOW_PATH";
		public static const CL_UNIT_ACTION_HIT:String = (Config.MESSAGE_TYPE_COMPACT) ? "cuh" : "CL_UNIT_ACTION_HIT";
		public static const CL_UNIT_ACTION_GATHER:String = (Config.MESSAGE_TYPE_COMPACT) ? "cug" : "CL_UNIT_ACTION_GATHER";
		public static const CL_UNIT_ACTION_STOP:String = (Config.MESSAGE_TYPE_COMPACT) ? "cus" : "CL_UNIT_ACTION_STOP";

		public static const CL_ENTITY_DEATH:String = (Config.MESSAGE_TYPE_COMPACT) ? "ced" : "CL_ENTITY_DEATH";
		public static const CL_RESOURCE_UPDATE:String = (Config.MESSAGE_TYPE_COMPACT) ? "cru" : "CL_RESOURCE_UPDATE";

		public static const CL_CHAT_MESSAGE:String = (Config.MESSAGE_TYPE_COMPACT) ? "ccm" : "CL_CHAT_MESSAGE";
		public static const CL_LOBBY_READY:String = (Config.MESSAGE_TYPE_COMPACT) ? "clr" : "CL_LOBBY_READY";
		public static const CL_READY:String = (Config.MESSAGE_TYPE_COMPACT) ? "crd" : "CL_READY";

		// -----------------------------------------------------------------------------------------------------------
		// Server-to-client messages
		// -----------------------------------------------------------------------------------------------------------

		public static const SV_CHAT_MESSAGE:String = (Config.MESSAGE_TYPE_COMPACT) ? "scm" : "SV_CHAT_MESSAGE";

		public static const SV_PLAYER_JOINED:String = (Config.MESSAGE_TYPE_COMPACT) ? "spj" : "SV_PLAYER_JOINED";
		public static const SV_PLAYER_LEFT:String = (Config.MESSAGE_TYPE_COMPACT) ? "spl" : "SV_PLAYER_LEFT";
		public static const SV_PLAYER_REGISTER:String = (Config.MESSAGE_TYPE_COMPACT) ? "srr" : "SV_PLAYER_REGISTER";
		public static const SV_PLAYER_UNREGISTER:String = (Config.MESSAGE_TYPE_COMPACT) ? "sru" : "SV_PLAYER_UNREGISTER";

		public static const SV_UNIT_CREATE:String = (Config.MESSAGE_TYPE_COMPACT) ? "suc" : "SV_UNIT_CREATE";
		public static const SV_STRUCTURE_CREATE:String = (Config.MESSAGE_TYPE_COMPACT) ? "ssc" : "SV_STRUCTURE_CREATE";

		public static const SV_LOBBY_READY:String = (Config.MESSAGE_TYPE_COMPACT) ? "slr" : "SV_LOBBY_READY";
		public static const SV_GAME_START:String = (Config.MESSAGE_TYPE_COMPACT) ? "sgs" : "SV_GAME_START";
		public static const SV_GAME_BEGIN:String = (Config.MESSAGE_TYPE_COMPACT) ? "sgb" : "SV_GAME_BEGIN";

		public static const SV_NOTICE:String = (Config.MESSAGE_TYPE_COMPACT) ? "snt" : "SV_NOTICE";


	}
}

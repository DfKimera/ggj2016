package engine.networking {
	public class MessageTypes {

		public static const CL_UNIT_CREATE:String = "cuc";
		public static const CL_UNIT_MOVE:String = "cum";
		public static const CL_UNIT_ATTACK:String = "cua";
		public static const CL_UNIT_FOLLOW:String = "cuf";
		public static const CL_UNIT_GATHER:String = "cug";
		public static const CL_UNIT_DEATH:String = "cud";
		public static const CL_STRUCTURE_CREATE:String = "csc";
		public static const CL_RESOURCE_UPDATE:String = "cru";
		public static const CL_CHAT_MESSAGE:String = "ccm";
		public static const CL_LOBBY_READY:String = "clr";
		public static const CL_READY:String = "crd";

		public static const SV_CHAT_MESSAGE:String = "scm";
		public static const SV_PLAYER_JOINED:String = "spj";
		public static const SV_PLAYER_LEFT:String = "spl";
		public static const SV_PLAYER_REGISTER:String = "srr";
		public static const SV_PLAYER_UNREGISTER:String = "sru";
		public static const SV_UNIT_CREATE:String = "suc";
		public static const SV_STRUCTURE_CREATE:String = "ssc";
		public static const SV_LOBBY_READY:String = "slr";
		public static const SV_GAME_START:String = "sgs";
		public static const SV_NOTICE:String = "snt";
		public static const SV_GAME_BEGIN:String = "sgb";


	}
}

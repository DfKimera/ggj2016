using System;
namespace GGJ2016 {

	public class MessageTypes {
		public const String CL_UNIT_CREATE = "cuc";
		public const String CL_UNIT_MOVE = "cum";
		public const String CL_UNIT_ATTACK = "cua";
		public const String CL_UNIT_FOLLOW = "cuf";
		public const String CL_UNIT_GATHER = "cug";
		public const String CL_UNIT_DEATH = "cud";
		public const String CL_STRUCTURE_CREATE = "csc";
		public const String CL_RESOURCE_UPDATE = "cru";
		public const String CL_CHAT_MESSAGE = "ccm";
		public const String CL_LOBBY_READY = "clr";
		public const String CL_READY = "crd";
		
		public const String SV_CHAT_MESSAGE = "scm";
		public const String SV_PLAYER_JOINED = "spj";
		public const String SV_PLAYER_LEFT = "spl";
		public const String SV_PLAYER_REGISTER = "srr";
		public const String SV_PLAYER_UNREGISTER = "sru";
		public const String SV_UNIT_CREATE = "suc";
		public const String SV_STRUCTURE_CREATE = "ssc";
		public const String SV_LOBBY_READY = "slr";
		public const String SV_GAME_START = "sgs";
		public const String SV_NOTICE = "snt";
		public const String SV_GAME_BEGIN = "sgb";
	}

}


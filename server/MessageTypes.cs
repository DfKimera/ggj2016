using System;
namespace GGJ2016 {

	public class MessageTypes {

		// -----------------------------------------------------------------------------------------------------------
		// Client-server and P2P messages
		// -----------------------------------------------------------------------------------------------------------
		
		public const String CL_UNIT_CREATE = (Config.MESSAGE_TYPE_COMPACT) ? "cuc" : "CL_UNIT_CREATE";
		public const String CL_STRUCTURE_CREATE = (Config.MESSAGE_TYPE_COMPACT) ? "csc" : "CL_STRUCTURE_CREATE";
		
		public const String CL_UNIT_ACTION_FOLLOW_PATH = (Config.MESSAGE_TYPE_COMPACT) ? "cuf" : "CL_UNIT_ACTION_FOLLOW_PATH";
		public const String CL_UNIT_ACTION_HIT = (Config.MESSAGE_TYPE_COMPACT) ? "cuh" : "CL_UNIT_ACTION_HIT";
		public const String CL_UNIT_ACTION_GATHER = (Config.MESSAGE_TYPE_COMPACT) ? "cug" : "CL_UNIT_ACTION_GATHER";
		public const String CL_UNIT_ACTION_STOP = (Config.MESSAGE_TYPE_COMPACT) ? "cus" : "CL_UNIT_ACTION_STOP";
		
		public const String CL_ENTITY_DEATH = (Config.MESSAGE_TYPE_COMPACT) ? "ced" : "CL_ENTITY_DEATH";
		public const String CL_RESOURCE_UPDATE = (Config.MESSAGE_TYPE_COMPACT) ? "cru" : "CL_RESOURCE_UPDATE";
		
		public const String CL_CHAT_MESSAGE = (Config.MESSAGE_TYPE_COMPACT) ? "ccm" : "CL_CHAT_MESSAGE";
		public const String CL_LOBBY_READY = (Config.MESSAGE_TYPE_COMPACT) ? "clr" : "CL_LOBBY_READY";
		public const String CL_READY = (Config.MESSAGE_TYPE_COMPACT) ? "crd" : "CL_READY";
		
		// -----------------------------------------------------------------------------------------------------------
		// Server-to-client messages
		// -----------------------------------------------------------------------------------------------------------
		
		public const String SV_CHAT_MESSAGE = (Config.MESSAGE_TYPE_COMPACT) ? "scm" : "SV_CHAT_MESSAGE";
		
		public const String SV_PLAYER_JOINED = (Config.MESSAGE_TYPE_COMPACT) ? "spj" : "SV_PLAYER_JOINED";
		public const String SV_PLAYER_LEFT = (Config.MESSAGE_TYPE_COMPACT) ? "spl" : "SV_PLAYER_LEFT";
		public const String SV_PLAYER_REGISTER = (Config.MESSAGE_TYPE_COMPACT) ? "srr" : "SV_PLAYER_REGISTER";
		public const String SV_PLAYER_UNREGISTER = (Config.MESSAGE_TYPE_COMPACT) ? "sru" : "SV_PLAYER_UNREGISTER";
		
		public const String SV_UNIT_CREATE = (Config.MESSAGE_TYPE_COMPACT) ? "suc" : "SV_UNIT_CREATE";
		public const String SV_STRUCTURE_CREATE = (Config.MESSAGE_TYPE_COMPACT) ? "ssc" : "SV_STRUCTURE_CREATE";
		
		public const String SV_LOBBY_READY = (Config.MESSAGE_TYPE_COMPACT) ? "slr" : "SV_LOBBY_READY";
		public const String SV_GAME_START = (Config.MESSAGE_TYPE_COMPACT) ? "sgs" : "SV_GAME_START";
		public const String SV_GAME_BEGIN = (Config.MESSAGE_TYPE_COMPACT) ? "sgb" : "SV_GAME_BEGIN";
		
		public const String SV_NOTICE = (Config.MESSAGE_TYPE_COMPACT) ? "snt" : "SV_NOTICE";

	}

}


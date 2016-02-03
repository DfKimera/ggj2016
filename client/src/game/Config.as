package game {
	import flash.text.TextFormat;

	CONFIG::developer
	public class Config {

		public static const GAME_ID:String = "ggj2016-usswxpgb60omafzefet3w";
		public static const CONN_ID:String = "public";
		public static const DEVELOPER_MODE:Boolean = true;
		public static const DEVELOPER_IP:String = "10.0.0.164:8184";

		public static const LOG_SHOW:Boolean = true;
		public static const MESSAGE_TYPE_COMPACT:Boolean = false;

		public static const COLOR_BTN_UP:Array = [0xff333333, 0xff666666];
		public static const COLOR_BTN_DOWN:Array = [0xff444444, 0xff777777];
		public static const COLOR_INPUT_DOWN:Array = [0xff222266, 0xff333377];
		public static const COLOR_INPUT_UP:Array = [0xff222222, 0xff111111];

		public static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF);

	}

	CONFIG::release
	public class Config {

		public static const GAME_ID:String = "ggj2016-usswxpgb60omafzefet3w";
		public static const CONN_ID:String = "public";
		public static const DEVELOPER_MODE:Boolean = false;
		public static const DEVELOPER_IP:String = "10.0.0.164:8184";

		public static const LOG_SHOW:Boolean = true;
		public static const MESSAGE_TYPE_COMPACT:Boolean = false;

		public static const COLOR_BTN_UP:Array = [0xff333333, 0xff666666];
		public static const COLOR_BTN_DOWN:Array = [0xff444444, 0xff777777];
		public static const COLOR_INPUT_DOWN:Array = [0xff222266, 0xff333377];
		public static const COLOR_INPUT_UP:Array = [0xff222222, 0xff111111];

		public static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF);

	}
}

package engine {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class RightClick {

		private static var _isPressed:Boolean = false;
		private static var _hasJustPressed:Boolean = false;

		public static function setup(root:Sprite):void {
			root.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, registerDown);
			root.addEventListener(MouseEvent.RIGHT_MOUSE_UP, registerUp);
		}

		public static function registerDown(ev:MouseEvent):void {
			_isPressed = true;
			_hasJustPressed = true;
		}

		public static function registerUp(ev:MouseEvent):void {
			_isPressed = false;
			_hasJustPressed = false;
		}

		public static function clearLastFrame():void {
			_hasJustPressed = false;
		}

		public static function isPressed():Boolean {
			return _isPressed;
		}

		public static function hasJustPressed():Boolean {
			return _hasJustPressed;
		}
	}
}

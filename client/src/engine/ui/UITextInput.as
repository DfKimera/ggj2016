package engine.ui {

	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	import game.Config;

	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;

	public class UITextInput extends FlxButtonPlus {

		static public var _mouseVisible:Boolean;
		static public var _deactivating:Boolean;

		protected var _input:TextField;
		protected var onChangeCallback:Function;

		public function UITextInput(_x:Number = 0, _y:Number = 0, _width:Number = 100, _height:Number = 20, _label:String = null, textFormat:TextFormat = null, onChangeCallback:Function = null) {
			super(_x, _y, show, null, _label, _width, _height);

			this.onChangeCallback = onChangeCallback;

			this.updateActiveButtonColors(Config.COLOR_INPUT_UP);
			this.updateInactiveButtonColors(Config.COLOR_INPUT_DOWN);

			_input = new TextField();
			_input.selectable = true;
			_input.type = TextFieldType.INPUT;
			_input.background = false;
			_input.textColor = 0xFFFFFF;
			_input.defaultTextFormat = textFormat;

			_deactivating = false;

		}
		override public function destroy():void {
			super.destroy();

			if (FlxG.stage != null) {
				_input.removeEventListener(Event.CHANGE, onChange);
				_input.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				FlxG.stage.addEventListener(Event.ACTIVATE, onActivate);
				FlxG.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			}
		}
		public function show():void {
			_mouseVisible = FlxG.mouse.visible;

			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			FlxG.stage.addChild(_input);

			textNormal.visible = textHighlight.visible = false;

			_input.text = textNormal.text;
			_input.setSelection(_input.length, _input.length);
			_input.x = x * FlxCamera.defaultZoom;
			_input.y = y * FlxCamera.defaultZoom;
			_input.width = width * FlxCamera.defaultZoom;
			_input.height = height * FlxCamera.defaultZoom;
			_input.addEventListener(Event.CHANGE, onChange);
			_input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_input.addEventListener(KeyboardEvent.KEY_UP, checkIfEnterPressed);

			FlxG.stage.addEventListener(Event.ACTIVATE, onActivate);
			FlxG.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			FlxG.stage.focus = _input;

			active = false;
		}
		protected function onChange(_event:Event):void {
			textNormal.text = _input.text;
			textHighlight.text = _input.text;
		}
		static protected function onActivate(_event:Event):void {
			_deactivating = false;
			FlxG.stage.removeEventListener(Event.ACTIVATE, onActivate);
		}
		static protected function onDeactivate(_event:Event):void {
			_deactivating = true;
			FlxG.stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
		}
		protected function onFocusOut(_event:Event):void {
			if (_mouseVisible) FlxG.mouse.show();
			if(!_deactivating) flash.ui.Mouse.hide();

			_input.removeEventListener(Event.CHANGE, onChange);
			_input.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);

			FlxG.stage.removeChild(_input);

			active = true;
			textNormal.visible = textHighlight.visible = true;

			if(onChangeCallback is Function) onChangeCallback(_input.text);
		}

		protected function checkIfEnterPressed(ev:KeyboardEvent):void {
			if(ev.keyCode == Keyboard.ENTER) {
				this.onFocusOut(ev);
				ev.preventDefault();
			}
		}

		public function clearText():void {
			textNormal.text = textHighlight.text = _input.text = "";
		}

		public function getValue():String {
			return _input.text;
		}
	}
}
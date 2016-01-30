package engine.interfaces {
	public interface Selectable {
		function onSelect():void;
		function onDeselect():void;
		function onCommand(command:int, parameters:Array):void;
	}
}

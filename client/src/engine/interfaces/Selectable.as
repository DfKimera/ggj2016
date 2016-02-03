package engine.interfaces {
	public interface Selectable {
		function onSelect():void;
		function onDeselect():void;
		function onLocalCommand(command:int, parameters:Array):void;
	}
}

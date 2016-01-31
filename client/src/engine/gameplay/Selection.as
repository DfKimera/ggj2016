package engine.gameplay {
	import engine.*;
	import game.Assets;

	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;

	public class Selection {

		public var selectedStructure:Structure;
		public var selectedUnits:Array = [];

		public var selectionMarker:FlxSprite;

		public function Selection():void {
			selectionMarker = new FlxSprite(0, 0, Assets.SELECTION_MARKER);
		}

		private function clearStructureSelection():void {
			if(selectedStructure) {
				selectedStructure.onDeselect();
			}

			selectedStructure = null;
		}

		private function clearUnitSelection():void {
			if(selectedUnits.length > 0) {
				for each(var unit:Unit in selectedUnits) {
					unit.onDeselect();
				}
			}

			selectedUnits = [];
		}

		public function clearSelection():void {
			clearStructureSelection();
			clearUnitSelection();
		}

		public function selectUnit(unit:Unit):void {
			clearSelection();

			selectedUnits = [unit];

			unit.onSelect();
		}

		public function selectUnits(units:Array):void {
			clearSelection();

			selectedUnits = units;

			for each(var unit:Unit in units) {
				unit.onSelect();
			}
		}

		public function addUnitToSelection(unit:Unit):void {
			clearStructureSelection();
			selectedUnits.push(unit);
			unit.onSelect();
		}

		public function hasSomethingSelected():Boolean {
			return (selectedStructure != null) || selectedUnits.length > 0;
		}

		public function hasStructureSelected():Boolean {
			return (selectedStructure != null);
		}

		public function hasUnitSelected():Boolean {
			return selectedUnits.length > 0;
		}

		public function getSelected():Array {
			if(hasSomethingSelected()) return [];

			if(hasStructureSelected()) {
				return [selectedStructure];
			}

			return selectedUnits;
		}

		public function commandSelected(command:int, parameters:Array = null):void {
			if(hasStructureSelected()) {
				if(!selectedStructure.alive) return;

				selectedStructure.onCommand(command, parameters);

				return;
			}

			if(hasUnitSelected()) {
				for each(var unit:Unit in selectedUnits) {
					if(!unit.alive) continue;
					unit.onCommand(command, parameters);
				}
			}
		}

	}
}

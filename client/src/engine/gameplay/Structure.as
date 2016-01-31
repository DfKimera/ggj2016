package engine.gameplay {

	import engine.states.RTSMatch;

	public class Structure extends Entity {

		public var type:String;

		public function Structure(id:int, owner:int, type:String, x:Number, y:Number, match:RTSMatch) {
			super(id, owner, x, y, match);
			this.type = type;
		}

		public override function toString():String {
			return "<Structure:" + type + ":" + owner + "; id=" + id + "; type=" + type + "; pos=" + x + "," + y + ">";
		}
	}
}

package engine.services {
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;

	public class Utils {

		public static function serializePath(path:FlxPath):String {
			var nodes:Array = [];

			for (var i in path.nodes) {
				if(!path.nodes.hasOwnProperty(i)) continue;

				var node:FlxPoint = path.nodes[i] as FlxPoint;
				nodes.push(int(node.x) + "," + int(node.y));

			}

			return nodes.join(";")
		}

		public static function deserializePath(serialized:String):FlxPath {
			var path:FlxPath = new FlxPath();
			var nodes:Array = serialized.split(";");

			for each(var node:String in nodes) {
				var n:Array = node.split(",");
				path.add(Number(n[0]), Number(n[1]));
			}

			return path;
		}

	}
}

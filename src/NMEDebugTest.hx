package ;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>
 */

import deep.nme.debug.Dump;
import nme.events.KeyboardEvent;
import haxe.Log;
import nme.display.Bitmap;
import haxe.Timer;
import nme.display.BitmapData;
import deep.nme.debug.NMEDebug;
import de.polygonal.core.Root;
import nme.display.Sprite;

class NMEDebugTest extends Sprite
{
	public function new()
	{
		super();
	}

	@:keep static function main()
	{
		var c =new NMEDebugConfig();
		c.hideKeyCodes = [];
		NMEDebug.init();
		Deb.logger = Root.log;

		var s = nme.Lib.current.stage;

		s.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

		var r = flash.net.SharedObject.getLocal("test");
		if (Reflect.fields(r.data).length == 0)
		{
			r.data.a = 1;
			r.data.b = "test";
			r.data.c = [1, 2];
			r.flush();
		}

		trace(Std.string(r.data));
		trace(r.size);

		trace(Dump.dumpFields(2, ["a"]));
		trace(Dump.dumpFields("as", ["length"]));
		trace(Dump.dumpFields(null, ["length"]));
		trace(Dump.dumpFields([1, 2], ["length"]));
	}

	static function onKeyDown(e:KeyboardEvent)
	{
		Deb.debug(Dump.dumpFields(e, ["keyCode", "charCode", "keyLocation"]));
	}
}

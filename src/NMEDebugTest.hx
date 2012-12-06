package ;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>
 */

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
	}

	static function onKeyDown(e:KeyboardEvent)
	{
		trace(Dump.dumpFields(e, ["keyCode", "charCode", "keyLocation"]));
	}
}

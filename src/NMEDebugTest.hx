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

		var sh = new nme.display.Shape();
		sh.graphics.lineStyle();
		sh.graphics.beginFill(0xFF0000);
		sh.graphics.drawCircle(0, 0, 50);

		trace(sh);

		s.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	static function onKeyDown(e:KeyboardEvent)
	{
		trace(Dump.dumpFields(e, ["keyCode", "charCode", "keyLocation"]));
	}
}

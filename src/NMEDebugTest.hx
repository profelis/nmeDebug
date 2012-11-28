package ;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>
 */

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
        NMEDebug.init();
        Deb.logger = Root.log;
        NetDeb.logger = Root.log;

        var b = new BitmapData(30, 30, false);
        b.fillRect(b.rect, 0x00FFFF);

        Deb.info(b);

        var m = new NMEDebugTest();
        nme.Lib.current.addChild(m);
        m.addChild(new Bitmap(b));

        var t = new Timer(1000);
        t.run = function () {Deb.info(b); t.stop(); }

        var a = {a:1, b:2, c:m};
        trace(a);
        trace(Std.string(a));
        trace(de.polygonal.core.fmt.Dump.object(a));
    }
}

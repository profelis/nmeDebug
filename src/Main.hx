package ;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>, <deep@e-citrus.ru>
 */

import haxe.Log;
import nme.display.Bitmap;
import haxe.Timer;
import nme.display.BitmapData;
import deep.nme.debug.NMEDebug;
import de.polygonal.core.Root;
import nme.display.Sprite;

class Main extends Sprite
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

        var b = new BitmapData(30, 200, false);
        b.fillRect(b.rect, 0x00FFFF);

        Deb.info(b);

        var m = new Main();
        nme.Lib.current.addChild(m);
        m.addChild(new Bitmap(b));

        var t = new Timer(1000);
        t.run = function () {Deb.debug(m); t.stop();}
    }
}

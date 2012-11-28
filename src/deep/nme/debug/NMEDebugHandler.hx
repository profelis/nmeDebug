package deep.nme.debug;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>, <deep@e-citrus.ru>
 */

import de.polygonal.core.log.LogHandler;

class NMEDebugHandler extends LogHandler
{
    var nmeDebug:NMEDebug;

    public function new(nmeDebug:NMEDebug)
    {
        super();
        this.nmeDebug = nmeDebug;
    }

    public override function output(data:String):Void
    {
        nmeDebug.output(data, _message);
    }

    override public function free():Void
    {
        if (nmeDebug == null) return;
        var d = nmeDebug;
        nmeDebug = null;

        d.dispose();

        super.free();
    }
}

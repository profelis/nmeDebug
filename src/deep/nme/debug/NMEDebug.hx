package deep.nme.debug;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>
 */

import de.polygonal.core.Root;
import nme.display.Bitmap;
import nme.events.MouseEvent;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.ui.Keyboard;
import nme.events.KeyboardEvent;
import nme.events.Event;
import nme.text.TextFieldAutoSize;
import nme.text.TextField;
import nme.display.Sprite;

import de.polygonal.core.log.LogMessage;

class NMEDebugConfig
{
    public var bgColor = 0xFFFFFF;
    public var bgAlpha = 0.6;

    public var hideKeyCodes:Array<Int>;
    public var lineScroll = 20;
    public var pageScroll = 200;

    public var bitmapMarkerColor = 0x888888;
    public var bitmapMarkerAlpha = 1;

    public var xOffset = 1;

    public function new()
    {
        hideKeyCodes = [106, 192]; // ~ *
    }
}

class NMEDebug extends Sprite
{
    static public function init(keepNativeTrace = false):NMEDebug
    {
        var d = new NMEDebug();
        nme.Lib.current.stage.addChild(d);

        Root.init([d.logHandler], keepNativeTrace);
        return d;
    }

    public var logHandler(default, null):NMEDebugHandler;

    var cont:Sprite;
    var dy:Float = 0;
    var autoScroll:Bool = true;

    var config:NMEDebugConfig;

    public function new(config:NMEDebugConfig = null)
    {
        super();
        this.config = config == null ? new NMEDebugConfig() : config;

        logHandler = new NMEDebugHandler(this);

        addChild(cont = new Sprite());
        cont.x = this.config.xOffset;

        addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    function onStage(_)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onStage);

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(Event.RESIZE, onResize);
        stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

        onResize();
    }

    public function dispose()
    {
        if (config == null) return;

        config = null;
        logHandler.free();
        logHandler = null;

        var s = nme.Lib.current.stage;
        s.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        s.removeEventListener(Event.RESIZE, onResize);
        s.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

        if (contains(cont)) removeChild(cont);
        if (parent != null) parent.removeChild(this);
    }

    function onResize(?_)
    {
        if (config.bgAlpha > 0)
        {
            graphics.clear();
            graphics.lineStyle();
            graphics.beginFill(config.bgColor, config.bgAlpha);
            graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        }
    }

    function onKeyDown(e:KeyboardEvent)
    {
        if (Lambda.has(config.hideKeyCodes, e.keyCode))
        {
            visible = !visible;
        }
        else if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.PAGE_UP)
        {
            scrollUp(e.keyCode == Keyboard.UP ? config.lineScroll : config.pageScroll);
        }
        else if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.PAGE_DOWN)
        {
            scrollDown(e.keyCode == Keyboard.DOWN ? config.lineScroll : config.pageScroll);
        }
    }

    inline function scrollUp(delta:Float)
    {
        cont.y += delta;
        if (cont.y > 0) cont.y = 0;
        autoScroll = false;
    }

    inline function scrollDown(delta:Float)
    {
        cont.y -= delta;
        var p = preferredScroll();
        if (cont.y <= p)
        {
            cont.y = p;
            autoScroll = true;
        }
    }

    function onWheel(e:MouseEvent)
    {
        if (e.delta > 0)
            scrollUp(e.delta * config.lineScroll);
        else
            scrollDown(-e.delta * config.lineScroll);
    }

    public function output(s:String, msg:LogMessage)
    {
        var t = new TextField();
        if (stage != null) t.width = stage.stageWidth;
        t.multiline = t.wordWrap = true;
        t.autoSize = TextFieldAutoSize.LEFT;
        t.selectable = true;
        t.text = s;
        t.y = dy;
        cont.addChild(t);
        dy += t.height;

        if (Std.is(msg.data, BitmapData))
        {
            logBitmap(new Bitmap(cast msg.data), t);
        }
        else if (Std.is(msg.data, Bitmap))
        {
            logBitmap(cast msg.data, t);
        }
        else if (Std.is(msg.data, DisplayObject))
        {
            var d:DisplayObject = cast msg.data;
            var bd = new BitmapData(Std.int(d.width), Std.int(d.height), true, 0x00000000);
            bd.draw(d);

            logBitmap(new Bitmap(bd), t, false);
        }

        if (autoScroll) cont.y = preferredScroll();
    }

    function logBitmap(b:Bitmap, t:TextField, extra = true)
    {
        var h = t.height;
        t.text += ", size: (" + b.width + ", " + b.height + ")";
        if (extra) t.text += ", transparent: " + b.bitmapData.transparent;
        dy += t.height - h;

        cont.addChild(b);
        b.y = dy;
        b.x = 11;

        if (config.bitmapMarkerAlpha > 0)
        {
            cont.graphics.lineStyle();
            cont.graphics.beginFill(config.bitmapMarkerColor, config.bitmapMarkerAlpha);
            cont.graphics.drawRect(0, dy, 10, b.height);
        }

        dy += b.height + 10;
    }

    inline function preferredScroll()
    {
        return Math.min(0, stage.stageHeight - dy);
    }
}

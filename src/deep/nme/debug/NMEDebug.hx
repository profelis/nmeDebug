package deep.nme.debug;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>
 */

import Lambda;

import nme.geom.Matrix;
import nme.display.Bitmap;
import nme.events.MouseEvent;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.geom.Rectangle;
import nme.ui.Keyboard;
import nme.events.KeyboardEvent;
import nme.events.Event;
import nme.text.TextFieldAutoSize;
import nme.text.TextField;
import nme.display.Sprite;

import de.polygonal.core.Root;
import de.polygonal.core.log.LogMessage;

using Lambda;

class NMEDebugConfig
{
	public var bgColor = 0xC6E2FF;
	public var bgAlpha = 1;

	public var textColor = 0x000000;

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
	static public function init(config:NMEDebugConfig = null, keepNativeTrace = false):NMEDebug
	{
		var d = new NMEDebug(config);
		nme.Lib.current.stage.addChild(d);

		Root.initLog([d.logHandler], keepNativeTrace);
		var msg = "NMEDebug panel initialized";
		if (d.config.hideKeyCodes.length > 0) msg += ": press key " + d.config.hideKeyCodes.join(" or ") + " to hide panel";
		Root.debug(msg);

		return d;
	}

	public var logHandler(default, null):NMEDebugHandler;

	var cont:Sprite;
	var dy = 0.0;
	var autoScroll = true;

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
		if (logHandler != null)
		{
			var l = logHandler;
			logHandler = null;
			l.free();
		}
		if (config == null) return;

		config = null;

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
		if (config.hideKeyCodes.has(e.keyCode))
		{
			visible = !visible;
		}
		else
		{
			switch(e.keyCode)
			{
				case Keyboard.UP: scrollUp(config.lineScroll);
				case Keyboard.PAGE_UP: scrollUp(config.pageScroll);
				case Keyboard.DOWN: scrollDown(config.lineScroll);
				case Keyboard.PAGE_DOWN: scrollDown(config.pageScroll);
			}
		}
	}

	function scrollUp(delta:Float)
	{
		cont.y += delta;
		if (cont.y > 0) cont.y = 0;
		autoScroll = false;
	}

	function scrollDown(delta:Float)
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
		t.textColor = config.textColor;
		t.text = s;
		t.y = dy;
		cont.addChild(t);
		dy += t.height;

		if (Std.is(msg.data, BitmapData))
		{
			logBitmap(new Bitmap(cast msg.data), t);
		}
		else if (Std.is(msg.data, DisplayObject))
		{
			var d:DisplayObject = cast msg.data;
			var r = d.getBounds(d);
			if (r.width > 0 && r.height > 0)
			{
				var bd = new BitmapData(Math.ceil(r.width), Math.ceil(r.height), true, 0x00000000);
				bd.draw(d, new Matrix(1, 0, 0, 1, -r.x, -r.y), null, null, null, true);

				logBitmap(new Bitmap(bd), t, r);
			}
			else
			{
				logBitmap(null, t, r);
			}
		}

		if (autoScroll) cont.y = preferredScroll();
	}

	function logBitmap(b:Bitmap, t:TextField, extra:Rectangle = null)
	{
		var h = t.height;
		if (extra == null)
		{
			t.text += ", size: (" + b.width + ", " + b.height + ")" +
					", transparent: " + b.bitmapData.transparent;
		}
		else
		{
			t.text += ", rect: " + Std.string(extra);
		}
		dy += t.height - h;

		if (b != null)
		{
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
	}

	@:extern inline function preferredScroll():Float
	{
		return Math.min(0, stage.stageHeight - dy);
	}
}

package ;

/**
 * @author Dima Granetchi <system.grand@gmail.com>
 */

import haxe.PosInfos;
import de.polygonal.core.log.Log;

class NetDeb
{
	static public var logger(default, default):Log;

	inline static public function log(a:Dynamic, ?posInfos:PosInfos):Void
	{
		#if netlog
		logger.debug(a, posInfos);
		#end
	}

	inline static public function info(a:Dynamic, ?posInfos:PosInfos):Void
	{
		#if netlog
		logger.info(a, posInfos);
		#end
	}

	inline static public function debug(a:Dynamic, ?posInfos:PosInfos):Void
	{
		#if netlog
		logger.debug(a, posInfos);
		#end
	}

	inline static public function warn(a:Dynamic, ?posInfos:PosInfos):Void
	{
		#if netlog
		logger.warn(a, posInfos);
		#end
	}

	inline static public function error(a:Dynamic, ?posInfos:PosInfos):Void
	{
		#if netlog
		logger.error(a, posInfos);
		#end
	}
}


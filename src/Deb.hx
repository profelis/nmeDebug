package ;
/**
 * User: Dima Grametchi
 * Date: 4/16/11
 * Time: 2:37 PM
 */
import de.polygonal.core.log.Log;

/**
 * Логгер, делегирует все вызовы в logger.
 * Расположен в верхнем уровне, чтобы предотвратить импорт пакета.
 */
class Deb
{
    static public var logger(default, default):Log;

    #if log
    static public var debug:Dynamic = Reflect.makeVarArgs(_debug);
    static public var info:Dynamic = Reflect.makeVarArgs(_info);
    static public var fatal:Dynamic = Reflect.makeVarArgs(_fatal);
    static public var warn:Dynamic = Reflect.makeVarArgs(_warn);
    #else
    inline static public function debug(a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic):Void {}
    inline static public function info(a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic):Void {}
    inline static public function fatal(a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic):Void {}
    inline static public function warn(a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic):Void {}
    #end

    inline static public function _info(args:Array<Dynamic>):Void
    {
        if (logger != null) for (a in args) logger.info(a);
    }

    inline static public function _debug(args:Array<Dynamic>):Void
    {
        if (logger != null) for (a in args) logger.debug(a);
    }

    inline static public function _warn(args:Array<Dynamic>):Void
    {
        if (logger != null) for (a in args) logger.warn(a);
    }

    inline static public function _error(args:Array<Dynamic>):Void
    {
        if (logger != null) for (a in args) logger.error(a);
    }

    function new() {}
}


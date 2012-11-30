package ;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>, <deep@e-citrus.ru>
 */

class Dump
{
	function new() {}

	static public function dumpFields(data:Dynamic, fields:Array<String>):String
	{
		var res = new StringBuf();
		for (f in fields)
		{
			res.add(f + ":" + Reflect.field(data, f) + ", ");
		}

		return res.toString();
	}
}

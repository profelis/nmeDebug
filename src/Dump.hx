package ;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>, <deep@e-citrus.ru>
 */

class Dump
{
	function new() {}

	static public function dumpFields(data:Dynamic, fields:Array<String>, ?format:Dynamic -> String):String
	{
		var res = new Array<String>();
		for (f in fields)
		{
			var d = Reflect.field(data, f);
			res.push(f + ":" + (format != null ? format(d) : d));
		}

		return res.join(", ");
	}
}

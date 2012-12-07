package deep.nme.debug;

/**
 *  @author Dima Granetchi <system.grand@gmail.com>, <deep@e-citrus.ru>
 */

class Dump
{
	static inline public function dump(obj:Dynamic):String
	{
		return Std.string(obj);
	}

	static public function dumpFields(data:Dynamic, fields:Array<String>, ?format:Dynamic -> String):String
	{
		switch (Type.typeof(data))
		{
			case TObject, TClass(_), TEnum(_), TUnknown:

				var res = new Array<String>();
				for (f in fields)
				{
					var d = Reflect.field(data, f);
					res.push(f + ":" + (format != null ? format(d) : d));
				}
				return res.join(", ");

			default: return dump(data);
		}
	}
}

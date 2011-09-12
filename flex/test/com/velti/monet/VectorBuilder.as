package com.velti.monet
{
	import com.velti.monet.models.Publisher;

	public class VectorBuilder
	{
		public function build(array:Object, type:Class):Object {
			switch(type) {
				case Publisher :
					return Vector.<Publisher>(array);
					break;
				default :
					throw new Error("Type not implemented: " + type);
					break;
			}
		}
	}
}
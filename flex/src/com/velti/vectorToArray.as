package com.velti {
		public function vectorToArray(vector:*):Array {
			var returnVal:Array = []; 
			for (var i:uint = 0; i < vector.length; i++) {
				returnVal.push(vector[i]);
			}
			return returnVal;
		}
}
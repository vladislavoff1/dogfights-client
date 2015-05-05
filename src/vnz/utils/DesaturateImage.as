package vnz.utils {
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	/**
	 *
	 * @author vnz
	 */
	public class DesaturateImage {
		/**
		 *
		 */
		public function DesaturateImage() {

		}

		static public function apply(image : DisplayObject, amount : Number = 0, overFilters : Boolean = false) : void {
			var colorFilter : ColorMatrixFilter = new ColorMatrixFilter();
			var redIdentity : Array = [1, 0, 0, 0, 0];
			var greenIdentity : Array = [0, 1, 0, 0, 0];
			var blueIdentity : Array = [0, 0, 1, 0, 0];
			var alphaIdentity : Array = [0, 0, 0, 1, 0];
			var grayluma : Array = [.3, .59, .11, 0, 0];
			var colmatrix : Array = new Array();

			colmatrix = colmatrix.concat(interpolateArrays(grayluma, redIdentity, amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, greenIdentity, amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, blueIdentity, amount));
			colmatrix = colmatrix.concat(alphaIdentity); // alpha not affected

			// assign the new matrix to colorFilter
			colorFilter.matrix = colmatrix;

			// apply the filter to the image
			if (image.filters.length > 0) {
				var filters : Array;
				if (!overFilters) {
					filters = [colorFilter];
					filters = filters.concat(image.filters);
				} else {
					filters = image.filters.concat([colorFilter]);
				}
				image.filters = filters;
			} else {
				image.filters = [colorFilter];
			}
		}

		static private function interpolateArrays(ary1 : Array, ary2 : Array, amount : Number) : Array {
			var result : Array = (ary1.length >= ary2.length) ? ary1.slice() : ary2.slice();
			var i : uint = result.length;
			while (i--)
				result[i] = ary1[i] + (ary2[i] - ary1[i]) * amount;
			return result;
		}
	}
}
package com.velti.monet.models
{
	import mx.collections.ListCollectionView;

	public class CreativeAssetsInPlan extends ListCollectionView
	{
		public function CreativeAssetsInPlan() {
			this.list = CreativeLibraryItem.ads;
			filterFunction = filterFunc;
			refresh();
		}
		
		private function filterFunc(item:CreativeLibraryItem):Boolean {
			return item.numTimesUsedInPlan > 0;
		}
	}
}
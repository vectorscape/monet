package com.velti.monet.services
{
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.SavedPlansModel;
	
	import flash.net.SharedObject;

	public class PlanService
	{
		private static const PLANS_SO:String = "plansSO";
		private static const SAVED_PLANS:String = "savedPlans";
		
		[Inject(source="savedPlans")]
		public var savedPlans:SavedPlansModel;
		
		public function save(plan:Plan):void {
			savedPlans.setItemByIndex(plan);
			var so:SharedObject = SharedObject.getLocal(PLANS_SO);
			so.data[SAVED_PLANS] = savedPlans;
			// if you see ArgumentError: Error #2004: One of the parameters is invalid.
			// that means one of your constructors either:
			// a) is not a no arguments constructuor
			// b) the args to the constructor do not have default values
			// one of these conditions must be true in order 
			// to serialize the data
			// if you have problems deserializing the data
			// make sure you annotate each class with 
			// [RemoteClass] metadata
			var status:String = so.flush();
			trace(status);
			load();
		}
		
		public function load():void {
			var so:SharedObject = SharedObject.getLocal(PLANS_SO);
			var soPlans:SavedPlansModel = so.data[SAVED_PLANS] as SavedPlansModel;
			if(!soPlans) 
				savedPlans.source = [];
			else
				savedPlans.source = soPlans.source; 
			savedPlans.refresh();
		}
		
		public function deletePlan(plan:Plan):void {
			savedPlans.removeItemByIndex(plan.planID);
			var so:SharedObject = SharedObject.getLocal(PLANS_SO);
			so.data[SAVED_PLANS] = savedPlans;
			var status:String = so.flush();
			//trace(status);
			load();
		}
		
		public function deleteAll():void {
			var so:SharedObject = SharedObject.getLocal(PLANS_SO);
			so.clear();
			load();
		}
	}
}
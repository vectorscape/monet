package com.velti.monet.events
{
	import com.velti.monet.models.Plan;

	public class SavedPlansEvent extends BaseEvent
	{
		/**
		 * Event type that is dispatched when the system is 
		 * asked show the saved plans.
		 */		
		public static const SHOW_SAVED:String = "showSavedPlans";
		
		/**
		 * Event type that is dispatched when the system is 
		 * asked to save a plan. 
		 */		
		public static const SAVE_CURRENT:String = "saveCurrentPlan";
		
		/**
		 * Event type that is dispatched when the system is 
		 * asked to change the current plan. 
		 */		
		public static const SET_CURRENT:String = "setCurrentPlan";
		
		/**
		 * Event type that is dispatched when the user system is 
		 * asked to load the list of saved plans. 
		 */		
		public static const LOAD_SAVED:String = "loadPlans";
		/**
		 * Removes all saved plans.
		 * 
		 */		
		public static const REMOVE_ALL:String = "removeAllSavedPlans";
		/**
		 * The plan to act on. 
		 */		
		public var plan:Plan;
		
		public function SavedPlansEvent(type:String, plan:Plan = null, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.plan = plan;
		}
	}
}
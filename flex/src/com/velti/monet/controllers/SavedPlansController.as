package com.velti.monet.controllers
{
	import com.velti.monet.events.SavedPlansEvent;
	import com.velti.monet.models.Plan;
	import com.velti.monet.services.PlanService;
	import com.velti.monet.views.SavedPlansView;
	
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;
	import mx.core.Application;

	/**
	 * Controller for loading and saving plans 
	 * @author Clint Modien
	 * 
	 */	
	public class SavedPlansController
	{
		/**
		 * Handle to the current plan the user is working on. 
		 */		
		[Inject]
		public var plan:Plan;
		/**
		 * A ref to the plan service for saving and loading plans 
		 */		
		[Inject]
		public var planService:PlanService;
		/**
		 * The swiz central dispatcher 
		 */		
		[Dispatcher]
		public var dispatcher:IEventDispatcher
		/**
		 * Saves the current plan
		 */		
		[EventHandler(event="SavedPlansEvent.SAVE_CURRENT")]
		public function plan_save():void {
			planService.save(plan);
			Alert.show("Plan saved.","Success",4,Application.application as Sprite);
		}
		
		/**
		 * Loads the saved plans
		 */		
		[EventHandler(event="SavedPlansEvent.LOAD_SAVED")]
		public function plan_load():void {
			planService.load();
		}
		/**
		 * Show's the saved plans view 
		 */		
		[EventHandler(event="SavedPlansEvent.SHOW_SAVED")]
		public function showPlanView():void {
			dispatcher.dispatchEvent(new SavedPlansEvent(SavedPlansEvent.LOAD_SAVED));
			new SavedPlansView().show();
		}
		/**
		 * Sets the current plan to a new plan 
		 */		
		[EventHandler(event="SavedPlansEvent.SET_CURRENT")]
		public function setCurrent(e:SavedPlansEvent):void {
			plan.load(e.plan);
		}
		
		/**
		 * Removes all saved plans
		 */		
		[EventHandler(event="SavedPlansEvent.REMOVE_ALL")]
		public function removeAllSavedPlans():void {
			planService.deleteAll();
		}
	}
}
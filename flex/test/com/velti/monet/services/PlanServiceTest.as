package com.velti.monet.services 
{
	import com.velti.monet.models.Element;
	import com.velti.monet.models.ElementType;
	import com.velti.monet.models.Plan;
	import com.velti.monet.models.SavedPlansModel;
	import com.velti.monet.models.elementData.CampaignElementData;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	
	public class PlanServiceTest 
	{
		protected var sut:PlanService;
		
		[Before]
		public function setUp():void {
			sut = new PlanService();
			sut.savedPlans = new SavedPlansModel();
			sut.deleteAll();
		}
		
		[After]
		public function tearDown():void {
			sut = null;
		}
		
		[Test]
		public function testSaveAndLoad_works():void {
			
			var expected:Plan = new Plan();
			expected.planID = "asdf";
			sut.save(expected);
			assertThat(sut.savedPlans.length, 1);
			assertThat(expected.planID, sut.savedPlans[0].planID);
		}
		
		[Test]
		public function testThat_saveAndLoad_worksTwice():void {
			
			sut.load();
			var firstPlan:Plan = new Plan();
			firstPlan.planID = "asdf1";
			sut.save(firstPlan);
			var secondPlan:Plan = new Plan();
			secondPlan.planID = "asdf2";
			sut.save(secondPlan);
			assertThat(sut.savedPlans.length, 2);
			assertThat(firstPlan.planID, sut.savedPlans[0].planID);
			assertThat(secondPlan.planID, sut.savedPlans[1].planID);
		}
		
		[Test]
		public function testThat_delete_works():void {
			
			var firstPlan:Plan = new Plan();
			firstPlan.planID = "asdf3";
			sut.save(firstPlan);
			var secondPlan:Plan = new Plan();
			secondPlan.planID = "asdf4";
			sut.save(secondPlan);
			assertThat(firstPlan.planID, sut.savedPlans[0].planID);
			assertThat(secondPlan.planID, sut.savedPlans[1].planID);
			sut.deletePlan(firstPlan);
			sut.load();
			assertThat(1,sut.savedPlans.length);
			assertThat(secondPlan.planID,sut.savedPlans[0].planID);
		}
		
		[Test]
		public function testThat_canLoad_afterSave():void {
			sut.load();
			var firstPlan:Plan = new Plan();
			firstPlan.planID = "asdf1";
			sut.save(firstPlan);
			assertThat(firstPlan.planID, sut.savedPlans[0].planID);
			sut.load();
			assertThat(firstPlan.planID, sut.savedPlans[0].planID);
		}
		
		[Test]
		public function testThat_serializingCampaigns_works():void {
			sut.load();
			var firstPlan:Plan = new Plan();
			firstPlan.planID = "asdf1";
			var campaign:Element = new Element(ElementType.CAMPAIGN);
			var ced:CampaignElementData = campaign.data as CampaignElementData;
			ced.name = "3asdf";
			firstPlan.addItem(campaign);
			sut.save(firstPlan);
			assertThat(firstPlan.planID, sut.savedPlans[0].planID);
			assertEquals(1,firstPlan.campaigns.length);
			assertThat(firstPlan.campaigns[0] is Element);
			assertThat(firstPlan.campaigns[0].data.name, ced.name);
			sut.load();
			assertThat(firstPlan.planID, sut.savedPlans[0].planID);
			assertEquals(1,firstPlan.campaigns.length);
			assertThat(firstPlan.campaigns[0] is Element);
			assertThat(firstPlan.campaigns[0].data.name, ced.name);
		}
	}
}
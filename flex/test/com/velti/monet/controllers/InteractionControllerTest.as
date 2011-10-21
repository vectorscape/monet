package com.velti.monet.controllers
{
	import com.velti.monet.models.InteractionMode;
	import com.velti.monet.models.PresentationModel;
	
	import org.flexunit.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	/**
	 * Tests the InteractionController
	 *  
	 * @author Ian Serlin
	 */	
	public class InteractionControllerTest
	{	
		/**
		 * The suite under test (sut) 
		 */		
		public var sut:InteractionController;
		
		/**
		 * PM for use with the test. 
		 */		
		public var presentationModel:PresentationModel;
		
		/**
		 * setup method 
		 */		
		[Before]
		public function setUp():void {
			sut = new InteractionController();
			presentationModel = new PresentationModel();
			sut.presentationModel = presentationModel;
		}
		/**
		 * tearDown method 
		 */		
		[After]
		public function tearDown():void {
			sut = null;
			presentationModel = null;
		}
		
		
		[Test]
		public function testThat_changingInteraction_changesInThePresentationModel():void {
			assertThat( sut.presentationModel.interactionMode, not( InteractionMode.MAGIC ) );
			sut.interactionMode_change( InteractionMode.MAGIC );
			assertThat( sut.presentationModel.interactionMode, equalTo( InteractionMode.MAGIC ) );
		}
		
	}
}
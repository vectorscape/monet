package com.velti.monet.controls
{
	import com.velti.monet.events.PlanEvent;
	import com.velti.monet.models.Audience;
	import com.velti.monet.models.Campaign;
	import com.velti.monet.models.Element;
	import com.velti.monet.models.Plan;
	
	import flash.events.EventDispatcher;
	
	import mx.core.DragSource;
	import mx.events.DragEvent;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.nullValue;

	public class ElementRendererTest
	{		
		protected var sut:ElementRenderer;
		
		[Before]
		public function setUp():void
		{
			sut = new ElementRenderer();
		}
		
		[After]
		public function tearDown():void
		{
			sut = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testThat_dragDrop_dispatchesAPlanEventADD_withTheProperElementType():void {
			var element:Element = new Campaign();
			element.isTemplate = true;
			sut.element = element;
			var de:DragEvent = new DragEvent(DragEvent.DRAG_DROP);
			var ds:DragSource = new DragSource();
			ds.addData(element,"element");
			de.dragSource = ds;
			sut.dispatcher = new EventDispatcher();
			var listenerCalled:Boolean;
			sut.dispatcher.addEventListener(PlanEvent.ADD_ELEMENT, function onAddElement(event:PlanEvent):void {
				assertEquals(event.targetElement, element);
				assertNotNull(event.element);
				assertTrue(event.element is Campaign);
				listenerCalled = true;
			});
			sut.this_dragDrop(de);
			assertTrue(listenerCalled);
		}
	}
}
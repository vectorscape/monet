package com.velti.monet.models
{
	import com.velti.monet.views.elementEditors.AdvertisementEditView;
	import com.velti.monet.views.elementEditors.AudienceEditView;
	import com.velti.monet.views.elementEditors.CampaignEditView;
	import com.velti.monet.views.elementEditors.InteractionEditView;
	import com.velti.monet.views.elementEditors.PublisherPlacementEditView;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	{
		ElementConsts.buildConsts();
	}
	
	public class ElementConsts
	{
		public var defaultLabelResourceKey:String;
		public var editDialog:Class;
		public var decendantElementType:Class;
		
		internal static const CONSTS:Dictionary = new Dictionary();
		
		public static function getConst(element:Element):ElementConsts {
			var returnVal:ElementConsts = null;
			var className:String = getQualifiedClassName(element);
			var typeName:Class = getDefinitionByName(className) as Class;
			returnVal = CONSTS[getClassNameKey(typeName)] as ElementConsts;
			return returnVal;
		}
		
		internal static function buildConsts():void {
			
			var ec:ElementConsts = new ElementConsts();
			ec.defaultLabelResourceKey = "";
			ec.editDialog = null;
			ec.decendantElementType = null;
			CONSTS[getClassNameKey(Element)] = ec;
			
			ec = new ElementConsts();
			ec.defaultLabelResourceKey = "campaign";
			ec.editDialog = CampaignEditView;
			ec.decendantElementType = Audience;
			CONSTS[getClassNameKey(Campaign)] = ec;
			
			ec = new ElementConsts();
			ec.defaultLabelResourceKey = "audience";
			ec.editDialog = AudienceEditView;
			ec.decendantElementType = Publisher;
			CONSTS[getClassNameKey(Audience)] = ec;
			
			ec = new ElementConsts();
			ec.defaultLabelResourceKey = "publisher";
			ec.editDialog = PublisherPlacementEditView;
			ec.decendantElementType = Placement;
			CONSTS[getClassNameKey(Publisher)] = ec;
			
			ec = new ElementConsts();
			ec.defaultLabelResourceKey = "placement";
			ec.editDialog = PublisherPlacementEditView;
			ec.decendantElementType = Advertisement;
			CONSTS[getClassNameKey(Placement)] = ec;
			
			ec = new ElementConsts();
			ec.defaultLabelResourceKey = "advertisement";
			ec.editDialog = AdvertisementEditView;
			ec.decendantElementType = Interaction;
			CONSTS[getClassNameKey(Advertisement)] = ec;
			
			ec = new ElementConsts();
			ec.defaultLabelResourceKey = "interaction";
			ec.editDialog = InteractionEditView;
			ec.decendantElementType = Interaction;
			CONSTS[getClassNameKey(Interaction)] = ec;
		}
		
		internal static function getClassNameKey(type:Class):String {
			var element:Element = new type() as Element;
			var className:String = getQualifiedClassName(element);
			var classNameKey:String = className.replace(/\./g,"_");
			classNameKey = classNameKey.replace(/::/g,"__");
			return classNameKey;
		}
	}
}
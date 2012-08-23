package ru.nekit.gis.view
{
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.view.views.*;
	
	import spark.components.View;
	import spark.components.supportClasses.ViewNavigatorBase;
	import spark.events.ElementExistenceEvent;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "ApplicationMediator";
		
		private var _view:Main = null;
		private var _activeView:View = null;
		private var _gcTimer:Timer;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			_view = viewComponent as Main;
			super(NAME, viewComponent);
		}
		
		public function get view():Main
		{
			return _view;
		}
		
		public function get activeView():View
		{
			return _activeView;
		}
		
		override public function onRegister():void
		{
			_gcTimer = new Timer(60*1000);
			_gcTimer.addEventListener(TimerEvent.TIMER, gcHandler);
			_view.addEventListener(Event.ACTIVATE, activeHandler);
			_view.addEventListener(Event.DEACTIVATE, deactiveHandler);
			var navigators:Vector.<ViewNavigatorBase> = _view.navigators;
			const length:uint = navigators.length;
			for( var i:uint = 0; i < length; i++)
			{
				var navigator:ViewNavigatorBase = navigators[i];
				navigator.addEventListener(ElementExistenceEvent.ELEMENT_ADD, 		addElementHandler);
				navigator.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, 	removeElementHandler);
			}
			registerViewMediator(_view.tabbedNavigator.activeView);	
			_gcTimer.start();
		}
		
		private function activeHandler(event:Event):void
		{
			_view.frameRate = 24;
			_gcTimer.start();
		}
		
		private function deactiveHandler(event:Event):void
		{
			_view.frameRate = 1;
			_gcTimer.stop();
			System.gc();
		}
		
		private function addElementHandler(event:ElementExistenceEvent):void
		{
			registerViewMediator(event.element as View);
		}
		
		private function gcHandler(event:TimerEvent):void
		{
			System.gc();
		}
		
		private function removeElementHandler(event:ElementExistenceEvent):void
		{
			removeViewMediator(event.element as View);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.EXIT,
				NAMES.STARTUP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch( notification.getName() )
			{
				
				case NAMES.EXIT:
					
					applicationExit();
					
					break;
				
				case NAMES.STARTUP_COMPLETE:
					
					facade.sendNotification(NAMES.ACTIVATE);
					
					break;
				
				default:
					break;
				
			}
		}
		
		public function applicationExit():void
		{ 
			var exitingEvent:Event = new Event(Event.EXITING, false, true); 
			NativeApplication.nativeApplication.dispatchEvent(exitingEvent); 
			if ( !exitingEvent.isDefaultPrevented() )
				NativeApplication.nativeApplication.exit(); 
		} 
		
		private function addViewHandler(event:ElementExistenceEvent):void
		{
			registerViewMediator(event.element as View);
		}
		
		private function removeViewHandler(event:ElementExistenceEvent):void
		{
			removeViewMediator(event.element as View);
		}
		
		private function registerViewMediator(view:View):void
		{
			
			_activeView = view;
			var classType:Class = Object(view).constructor;
			var mediator:IMediator = null;
			
			switch( classType  )
			{
				
				case MeView:
					
					mediator = new MeMediator(view);
					
					break;
				
				case MapView:
					
					mediator = new MapMediator(view);
					
					break;
				
				default:
					
					break;
				
			}
			
			if( mediator )
				facade.registerMediator(mediator);
		}
		
		private function removeViewMediator(view:View):void
		{
			var classType:Class = Object(view).constructor;
			var name:String = null;
			switch( classType  )
			{
				
				case MeView:
					
					name = MeMediator.NAME;
					
					break;
				
				case MapView:
					
					name = MapMediator.NAME;
					
					break;
				
				default:
					
					break;
			}
			
			if( name )
				facade.removeMediator(name);
		}
	}
}
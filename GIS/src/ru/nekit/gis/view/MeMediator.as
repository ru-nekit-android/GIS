package ru.nekit.gis.view
{
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.model.proxy.PositionMessage;
	import ru.nekit.gis.model.proxy.SayMessage;
	import ru.nekit.gis.model.proxy.UserProxy;
	import ru.nekit.gis.model.vo.OfflineMessageVO;
	import ru.nekit.gis.model.vo.PositionVO;
	import ru.nekit.gis.service.DBService;
	import ru.nekit.gis.service.interfaces.IDBService;
	import ru.nekit.gis.view.views.MeView;
	
	public class MeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "HomeMediator";
		
		private var _view:MeView;
		private var user:UserProxy;
		
		public function MeMediator(viewComponent:Object=null)
		{
			_view = viewComponent as MeView;
			super(NAME, viewComponent);
		}
		
		public function get view():MeView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.GPS_UPDATE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var body:Object = notification.getBody();
			var position:PositionVO = body as PositionVO;
			
			switch( notification.getName() )
			{
				
				case NAMES.GPS_UPDATE:	
					
					_view.positionValue.text = position.toString();
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function exitHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.EXIT);
		}
		
		private function sayHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MESSAGE, _view.input.text, SayMessage.SAY);
		}
		
		private function sosHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MESSAGE, null, SayMessage.SOS);
		}
		
		private function hereHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MESSAGE, null, PositionMessage.HERE);
		}
		
		private function removeOfflineHandler(event:MouseEvent):void
		{
			var db:IDBService = facade.retrieveProxy(DBService.NAME) as IDBService;
			db.removeAll(OfflineMessageVO);
		}
		
		override public function onRegister():void
		{
			_view.exit.addEventListener(MouseEvent.CLICK, 	exitHandler);
			_view.say.addEventListener(MouseEvent.CLICK, 	sayHandler);
			_view.sos.addEventListener(MouseEvent.CLICK, 	sosHandler);
			_view.here.addEventListener(MouseEvent.CLICK, 	hereHandler);
			_view.removeOffline.addEventListener(MouseEvent.CLICK, removeOfflineHandler);
			user = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if( user && user.position )
				_view.positionValue.text = user.position.toString();
		}
		
		override public function  onRemove():void
		{
			_view.exit.removeEventListener(MouseEvent.CLICK, 	exitHandler);
			_view.say.removeEventListener(MouseEvent.CLICK, 	sayHandler);
			_view.sos.removeEventListener(MouseEvent.CLICK, 	sosHandler);
			_view.here.removeEventListener(MouseEvent.CLICK, 	hereHandler);
			_view.removeOffline.removeEventListener(MouseEvent.CLICK, removeOfflineHandler);
		}
	}
}
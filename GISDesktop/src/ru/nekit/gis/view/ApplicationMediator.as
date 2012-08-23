package ru.nekit.gis.view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.gis.NAMES;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "ApplicationMediator";
		
		private var _owner:Main;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			_owner = viewComponent as Main;
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.STARTUP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch( notification.getName() )
			{
				
				case NAMES.STARTUP_COMPLETE:
					
					facade.sendNotification(NAMES.CONNECTION);
					
					break;
				
				default:
					break;
				
			}
		}
		
		public function get owner():Main
		{
			return _owner;
		}
		
		override public function onRegister():void
		{
			facade.registerMediator(new MapFrameMediator(owner.mainFrame));
		}
	}
}
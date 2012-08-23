package ru.nekit.gis.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.model.proxy.PositionMessage;
	import ru.nekit.gis.model.proxy.UserProxy;
	import ru.nekit.gis.service.*;
	import ru.nekit.gis.view.ApplicationMediator;
	
	public class StartUpCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new DBService);
			facade.registerProxy(new NetConnectionService);
			facade.registerProxy(new GPSService);
			facade.registerProxy(new SynchronizationSevice);
			facade.registerProxy(new ConnectionDetectService);
			facade.registerProxy(new PositionMessage(PositionMessage.NOW));
			facade.registerProxy(new UserProxy());
			facade.registerMediator(new ApplicationMediator(notification.getBody()));
			sendNotification(NAMES.STARTUP_COMPLETE);
		}	
	}
}
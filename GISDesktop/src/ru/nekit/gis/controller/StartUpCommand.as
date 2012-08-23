package ru.nekit.gis.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.model.NetConnectionService;
	import ru.nekit.gis.view.ApplicationMediator;
	
	public class StartUpCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			
			facade.registerMediator(new ApplicationMediator(notification.getBody()));
			facade.registerProxy(new NetConnectionService);
			sendNotification(NAMES.STARTUP_COMPLETE);
			
		}	
	}
}
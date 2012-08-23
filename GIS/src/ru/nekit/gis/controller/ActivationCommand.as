package ru.nekit.gis.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.gis.service.*;
	import ru.nekit.gis.service.interfaces.*;
	
	public class ActivationCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var synchronization:ISynchronizationSevice	= facade.retrieveProxy(SynchronizationSevice.NAME) as ISynchronizationSevice;
			synchronization.activate();
			var connection:INetConnectionService 		= facade.retrieveProxy(NetConnectionService.NAME) as INetConnectionService;
			connection.activate();
			var gps:IGPSService 						= facade.retrieveProxy(GPSService.NAME) as IGPSService;
			gps.activate();
			gps.refreshInterval 						= 1000;
		}
	}
}
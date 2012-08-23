package ru.nekit.gis.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import ru.nekit.gis.model.INetConnectionService;
	import ru.nekit.gis.model.NetConnectionService;
	
	public class ConnectionCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var connection:INetConnectionService = facade.retrieveProxy(NetConnectionService.NAME) as INetConnectionService;
			connection.connect();
		}
	}
}
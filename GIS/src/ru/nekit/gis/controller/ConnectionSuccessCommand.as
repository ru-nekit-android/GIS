package ru.nekit.gis.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.gis.model.proxy.JoinMessage;
	import ru.nekit.gis.service.SynchronizationSevice;
	import ru.nekit.gis.service.interfaces.ISynchronizationSevice;
	
	public class ConnectionSuccessCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{	
			var synchronizer:ISynchronizationSevice = facade.retrieveProxy(SynchronizationSevice.NAME) as ISynchronizationSevice;
			synchronizer.send(new JoinMessage(JoinMessage.JOIN));
			synchronizer.synchronize();
		}	
	}
}
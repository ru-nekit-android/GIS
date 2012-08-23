package ru.nekit.gis.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.gis.model.proxy.PositionMessage;
	import ru.nekit.gis.model.proxy.SayMessage;
	import ru.nekit.gis.model.proxy.UserProxy;
	import ru.nekit.gis.model.vo.PositionVO;
	import ru.nekit.gis.model.vo.SayVO;
	import ru.nekit.gis.service.SynchronizationSevice;
	import ru.nekit.gis.service.interfaces.ISynchronizationSevice;
	
	public class MessageCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			
			var type:String = notification.getType();
			var body:Object = notification.getBody();
			var synchronizer:ISynchronizationSevice = facade.retrieveProxy(SynchronizationSevice.NAME) as ISynchronizationSevice;
			var positionP:PositionMessage;
			var position:PositionVO;
			var user:UserProxy   					= facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			
			synchronizer.synchronize();
			
			switch( type )
			{
				
				case SayMessage.STATUS:
					
					var value:String = String(body);
					synchronizer.send(new SayMessage(SayMessage.STATUS, new SayVO(value)));
					user.status = value;
					
					break;
				
				case SayMessage.SAY:
					
					synchronizer.send(new SayMessage(SayMessage.SAY, new SayVO(String(body))));
					
					break;
				
				case SayMessage.SOS:
					
					synchronizer.send(new SayMessage(SayMessage.SOS));
					
					break;
				
				case PositionMessage.HERE:
					
					positionP 			= facade.retrieveProxy(PositionMessage.NOW) as PositionMessage;
					position 			= positionP.vo;
					user.position		= position;
					
					synchronizer.send(new PositionMessage(PositionMessage.HERE, position));
					
					break;
				
				case null:
					
					position 			= body as PositionVO;
					positionP 			= facade.retrieveProxy(PositionMessage.NOW) as PositionMessage;
					positionP.vo 		= position;
					user.position		= position;
					
					synchronizer.send(new PositionMessage(PositionMessage.NOW, position));
					
					break;
				
				default:
					break;
			}
		}
	}
}
package ru.nekit.gis.service.interfaces
{
	import ru.nekit.gis.manager.entity.IEntity;
	import ru.nekit.gis.model.interfaces.IMessage;
	
	public interface ISynchronizationSevice
	{
		
		function activate():void;
		function send(value:IMessage):void;
		function list(value:Vector.<IEntity>):void;
		function synchronize():void;
		function get length():uint;
		function get inSynchronization():Boolean;
		
	}
}
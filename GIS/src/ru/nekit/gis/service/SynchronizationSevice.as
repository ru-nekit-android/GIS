package ru.nekit.gis.service
{
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.manager.entity.IEntity;
	import ru.nekit.gis.model.interfaces.IMessage;
	import ru.nekit.gis.model.vo.*;
	import ru.nekit.gis.service.interfaces.*;
	
	public class SynchronizationSevice extends Proxy implements IProxy, ISynchronizationSevice
	{
		
		public static const NAME:String = "synchronizationSevice";
		
		private var _list:Vector.<OfflineMessageVO> = new Vector.<OfflineMessageVO>;
		private var _inSynchronization:Boolean;
		private var connection:INetConnectionService;
		private var connectionDetect:IConnectionDetectService;
		private var db:IDBService;
		
		public function SynchronizationSevice()
		{
			super(NAME);
		}
		
		public function activate():void
		{
			connection 				= facade.retrieveProxy(NetConnectionService.NAME) as INetConnectionService;
			connectionDetect 		= facade.retrieveProxy(ConnectionDetectService.NAME) as IConnectionDetectService;
			db						= facade.retrieveProxy(DBService.NAME) as IDBService;
			db.createDatabase();
			db.create(HistoryMessageVO);
			db.create(OfflineMessageVO);
			list(db.selectAll(OfflineMessageVO));
			synchronize();
		}
		
		public function send(value:IMessage):void
		{
			var type:String								= value.name;
			var body:ByteArray							= value.serialize;
			var canSend:Boolean = connectionDetect.active && connection.send(getSendObject(type, body));
			db.save(new HistoryMessageVO(type, value));
			if( !canSend )
			{
				var offline:OfflineMessageVO = new OfflineMessageVO(type, value);
				db.save(offline);
				_list.push(offline);
			}
		}
		
		public function get inSynchronization():Boolean
		{
			return _inSynchronization;
		}
		
		public function synchronize():void
		{
			if( !_inSynchronization )
			{
				if( connectionDetect.active )
				{
					const length:uint 						= this.length;
					if( length > 0 )
					{
						var deleteCount:uint 				= 0;
						for( var i:uint = 0; i < length; i++)
						{
							var message:OfflineMessageVO 	= _list[0];
							if( connection.send(getSendObject(message.type, message.body)) )
							{
								db.remove(message);
								_list.splice(0, 1);
							}
						}
					}
					_inSynchronization = false;
				}
			}
		}
		
		private function getSendObject(type:String, body:ByteArray, date:Date = null):SendObjectVO
		{
			return new SendObjectVO(connectionDetect.macAddress, type, body, date)
		}
		
		public function get length():uint
		{
			return _list.length;
		}
		
		public function list(value:Vector.<IEntity>):void
		{
			const length:uint = value ? value.length : 0;
			for( var i:uint = 0; i < length; i++)
				_list.push(value[i] as OfflineMessageVO);
		}
	}
}
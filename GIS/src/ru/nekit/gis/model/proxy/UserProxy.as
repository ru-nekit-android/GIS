package ru.nekit.gis.model.proxy
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.model.vo.PositionVO;
	import ru.nekit.gis.service.serviceCommand.UserSC;
	import ru.nekit.gis.service.serviceUtil.properties.ServiceProcessBehavior;
	import ru.nekit.gis.service.serviceUtil.result.ServiceUtilResult;
	
	import spark.managers.PersistenceManager;
	
	public class UserProxy extends Proxy implements IProxy
	{
		
		private static const persistenceManager:PersistenceManager = new PersistenceManager();
		
		public static const NAME:String = "user";
		
		public var status:String;
		public var login:String;
		public var password:String;
		public var timestamp:Date;
		public var position:PositionVO;
		
		public function UserProxy()
		{
			super(NAME);
		}
		
		public function update():void
		{
			save();
		}
		
		private function save():void
		{
			persistenceManager.setProperty("userInfo", this);
			persistenceManager.save();
		}
		
		private function load():void
		{
			if( persistenceManager.load() )
			{
				var userInfo:Object = persistenceManager.getProperty("userInfo");
				if( userInfo )
				{
					login		= userInfo.login;
					password	= userInfo.password;
					if( userInfo.timestamp )
						timestamp	= new Date(userInfo.timestamp);
				}
			}
		}
		
		public function get checkIfLoggedIn():Boolean
		{
			var userProxy:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			userProxy.load();
			var now:Date 			= new Date;
			return  userProxy.timestamp && ( ( now.time - userProxy.timestamp.time ) < 10*60*1 );	
		}
		
		public function authorizationCall(macAddress:String):void
		{
			UserSC.authorization(login, password, macAddress).execute(ServiceProcessBehavior.withFunctions(
				function(result:ServiceUtilResult):void{
					if( result.result )
					{
						timestamp = new Date;
						save();
						sendNotification(NAMES.AUTHORIZATION_SUCCESS);
					}else
						sendNotification(NAMES.AUTHORIZATION_FAILURE, true);
				}
				,
				function(result:ServiceUtilResult):void{
					sendNotification(NAMES.AUTHORIZATION_FAILURE);
				}
			));
		}
		
	}
}
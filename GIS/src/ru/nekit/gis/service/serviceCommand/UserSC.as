package ru.nekit.gis.service.serviceCommand{
	
	import ru.nekit.gis.service.serviceUtil.description.AMFSD;
	
	public final class UserSC{
		
		public static const CLASS:String 							= "UserService";
		public static const AUTHORIZATION:String 					= "authorization";
		
		public static function authorization(login:String, password:String, mac:String):AMFSD
		{
			return new AMFSD(CLASS, AUTHORIZATION, login, password, mac);
		}
	}
}
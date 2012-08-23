package ru.nekit.gis.service
{
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.service.interfaces.IConnectionDetectService;
	
	public class ConnectionDetectService extends Proxy implements IProxy, IConnectionDetectService
	{
		
		public static const NAME:String = "connectionDetectService";
		
		private var _active:Boolean;
		
		public function ConnectionDetectService()
		{
			super(NAME);
		}
		
		public function get macAddress():String
		{
			if( active )
			{
				var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
				for(var i:uint = 0; i < interfaces.length; i++) 
					if( interfaces[i].name.toLowerCase() == "wifi" ) 
						return interfaces[i].hardwareAddress;
			}
			return null;
		}
		
		public function get active():Boolean
		{
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			for(var i:uint = 0; i < interfaces.length; i++) {
				if(interfaces[i].name.toLowerCase() == "wifi" && interfaces[i].active) {
					return true;
				} else if(interfaces[i].name.toLowerCase() == "mobile" && interfaces[i].active) {
					return true;
				}
			}
			return false;
		}
	}
}
package ru.nekit.gis.model.proxy
{
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.model.interfaces.IDeserialize;
	
	public class JoinMessage extends Proxy implements IProxy, IDeserialize
	{
		public static const JOIN:String 	= "join";
		
		public function JoinMessage(proxyName:String=null)
		{
			super( proxyName);
		}
		
		public function deserialize(ba:ByteArray):void
		{
		}
	}
}
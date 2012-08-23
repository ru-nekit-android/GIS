package ru.nekit.gis.model.proxy
{
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.model.interfaces.IMessage;
	
	public class JoinMessage extends Proxy implements IProxy, IMessage
	{
		public static const JOIN:String 	= "join";
		
		private var _name:String;
		
		public function JoinMessage(proxyName:String=null)
		{
			super( _name = proxyName);
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get serialize():ByteArray
		{
			return null;
		}
		
		public function deserialize(ba:ByteArray):void
		{
		}
	}
}
package ru.nekit.gis.model.proxy
{
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.model.interfaces.IMessage;
	import ru.nekit.gis.model.vo.SayVO;
	
	public class SayMessage extends Proxy implements IProxy, IMessage
	{
		
		public static const SAY:String 		= "say";
		public static const SOS:String 		= "sos";
		public static const STATUS:String 	= "status";
		
		private var _name:String;
		
		public function SayMessage(proxyName:String=null, data:Object=null)
		{
			super( _name = proxyName, data);
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get vo():SayVO
		{
			return data as SayVO;
		}
		
		public function set vo(value:SayVO):void
		{
			data = value;
		}
		
		public function get serialize():ByteArray
		{
			var ba:ByteArray;
			if( vo )
			{
				ba = new ByteArray;
				ba.writeUTF(vo.value);
			}
			return ba;
		}
		
		public function deserialize(value:ByteArray):void
		{
			vo = new SayVO(value.readUTF());
		}
	}
}
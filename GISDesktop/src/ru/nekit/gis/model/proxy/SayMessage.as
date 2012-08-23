package ru.nekit.gis.model.proxy
{
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.model.interfaces.IDeserialize;
	import ru.nekit.gis.model.vo.SayVO;
	
	public class SayMessage extends Proxy implements IProxy, IDeserialize
	{
		
		public static const SAY:String 		= "say";
		public static const SOS:String 		= "sos";
		public static const STATUS:String 	= "status";
		
		public function SayMessage(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			if( data is ByteArray )
				deserialize(ByteArray(data));
		}
		
		public function get vo():SayVO
		{
			return data as SayVO;
		}
		
		public function set vo(value:SayVO):void
		{
			data = value;
		}
		
		public function deserialize(ba:ByteArray):void
		{
			ba.position = 0;
			var vo:SayVO = new SayVO;
			vo.value = ba.readUTF();
			this.vo = vo;
		}
	}
}
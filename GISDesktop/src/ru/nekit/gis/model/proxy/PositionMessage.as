package ru.nekit.gis.model.proxy
{
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.model.interfaces.IDeserialize;
	import ru.nekit.gis.model.vo.PositionVO;
	
	public class PositionMessage extends Proxy implements IProxy, IDeserialize
	{
		
		public static const NOW:String = "now";
		public static const HERE:String = "here";
		
		public function PositionMessage(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			if( data is ByteArray )
				deserialize(ByteArray(data));
		}
		
		public function get vo():PositionVO
		{
			return data as PositionVO;
		}
		
		public function set vo(value:PositionVO):void
		{
			data = value;
		}
		
		public function deserialize(ba:ByteArray):void
		{
			ba.position = 0;
			var vo:PositionVO = new PositionVO;
			vo.lat = ba.readDouble();
			vo.lng = ba.readDouble();
			vo.alt = ba.readDouble();
			vo.horizontalAccuracy = ba.readFloat();
			vo.verticalAccuracy	  = ba.readFloat();
			this.vo = vo;
		}
	}
}
package ru.nekit.gis.model.proxy
{
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.model.interfaces.IMessage;
	import ru.nekit.gis.model.vo.PositionVO;
	
	public class PositionMessage extends Proxy implements IProxy, IMessage
	{
		
		public static const NOW:String = "now";
		public static const HERE:String = "here";
		
		private var _name:String;
		
		public function PositionMessage(proxyName:String=null, data:Object=null)
		{
			super( _name = proxyName, data);
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get vo():PositionVO
		{
			return data as PositionVO;
		}
		
		public function set vo(value:PositionVO):void
		{
			data = value;
		}
		
		public function get serialize():ByteArray
		{
			var ba:ByteArray = new ByteArray;
			ba.position = 0;
			ba.writeDouble(vo.lat);
			ba.writeDouble(vo.lng);
			ba.writeDouble(vo.alt);
			ba.writeFloat(vo.horizontalAccuracy);
			ba.writeFloat(vo.verticalAccuracy);
			return ba;
		}
		
		public function deserialize(ba:ByteArray):void
		{
			ba.position = 0;
			vo = new PositionVO(
				ba.readDouble(),
				ba.readDouble(),
				ba.readDouble(),
				ba.readFloat(),
				ba.readFloat()
			);
		}
	}
}
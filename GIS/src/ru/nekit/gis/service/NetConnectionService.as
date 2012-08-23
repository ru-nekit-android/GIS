package ru.nekit.gis.service
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.service.interfaces.INetConnectionService;
	
	public class NetConnectionService extends Proxy implements IProxy, INetConnectionService
	{
		public static const NAME:String = "netConnection";
		
		private var _connection:NetConnection;
		private var _group:NetGroup;
		
		private var _connected:Boolean = false;
		
		public function NetConnectionService()
		{
			super(NAME);
		}
		
		public function activate():void
		{
			_connection = new NetConnection;
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_connection.connect("rtmfp://p2p.rtmfp.net/","fa34a2a9cd8864b67cdb154d-ac8a93ff4df0");
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			trace( event.info.code);
			switch( event.info.code ){
				
				case "NetConnection.Connect.Success":
					
					setupGroup();
					
					break;
				
				case "NetGroup.Connect.Success":
					
					
					break;
				
				case "NetGroup.Posting.Notify":
					
					sendNotification(NAMES.NET_CONNECTION_NOTIFY, event.info.message);
					
					break;
				
				case "NetGroup.Neighbor.Connect":
					
					_connected = true;
					sendNotification(NAMES.NET_CONNECTION_SUCCESS);
					
					break;
				
				default:
					break;
				
			}	
		}
		
		public function get connected():Boolean
		{
			return _connected
		}
		
		private function setupGroup():void
		{
			var groupSpec:GroupSpecifier 	= new GroupSpecifier("localDeviceConnection");
			groupSpec.postingEnabled 		= true;
			groupSpec.serverChannelEnabled 	= true;
			_group = new NetGroup(_connection, groupSpec.groupspecWithoutAuthorizations());
			_group.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		public function send(message:*):Boolean
		{
			if( _connected )
			{
				var result:Boolean = _group.post(message) != null
				return result;
			}
			return false;
		}
	}
}
package ru.nekit.gis.model
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.NAMES;
	
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
		
		public function connect():void
		{
			_connection = new NetConnection;
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_connection.connect("rtmfp://p2p.rtmfp.net/","fa34a2a9cd8864b67cdb154d-ac8a93ff4df0");
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			trace( event.info.code);
			
			switch(event.info.code){
				
				case "NetConnection.Connect.Success":
					
					setupGroup();
					
					break;
				
				case "NetGroup.Posting.Notify":
					
					sendNotification(NAMES.NET_CONNECTION_NOTIFY, event.info.message);
					
					break;
				
				case "NetGroup.Connect.Success":
					
					_connected = true;
					
					break;
				
				default:
					break;
			}
		}
		
		private function setupGroup():void
		{
			var groupSpec:GroupSpecifier 	= new GroupSpecifier("localDeviceConnection");
			groupSpec.postingEnabled 		= true;
			groupSpec.serverChannelEnabled 	= true;
			_group = new NetGroup(_connection, groupSpec.groupspecWithoutAuthorizations());
			_group.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		public function send(message:*):void
		{
			_group.post(message);
		}
	}
}
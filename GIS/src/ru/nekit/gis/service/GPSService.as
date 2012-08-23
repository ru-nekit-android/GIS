package ru.nekit.gis.service {
	
	import flash.events.GeolocationEvent;
	import flash.sensors.Geolocation;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.service.interfaces.IGPSService;
	import ru.nekit.gis.model.vo.PositionVO;
	
	public class GPSService extends Proxy implements IProxy, IGPSService{
		
		public static const NAME:String = "GPSModel";
		
		private var _geoLoc:Geolocation;
		private var _support:Boolean;
		private var _currentLatLng:PositionVO;
		private var _refreshInterval:Number;
		private var _active:Boolean;
		
		public function GPSService() 
		{	
			super(NAME);
		}
		
		public function set refreshInterval(value:Number):void
		{
			_refreshInterval = value;
			if( _geoLoc )
				_geoLoc.setRequestedUpdateInterval(value);
		}
		
		public function get refreshInterval():Number
		{
			return _refreshInterval;
		}
		
		public function get support():Boolean 
		{
			return _support;
		}
		
		public function get currentLatLng():PositionVO 
		{
			return _currentLatLng;
		}
		
		public function activate():void 
		{
			_support 	= false;
			if( !_active )
			{
				_active 	= true;
				if( Geolocation.isSupported ) 
				{
					_support 	= true;
					_geoLoc 	= new Geolocation();
					if ( _support ) 
					{
						if (_geoLoc.muted) 
						{
							_support = false;
							deactivate();
						}
						else 
						{
							_geoLoc.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
						}
					}	
				}
			}
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		private function geoUpdateHandler(event:GeolocationEvent):void {
			_currentLatLng = new PositionVO(event.latitude, event.longitude, event.altitude, event.horizontalAccuracy, event.verticalAccuracy);
			sendNotification(NAMES.GPS_UPDATE, _currentLatLng);
		}
		
		public function deactivate():void 
		{
			if( _geoLoc.hasEventListener(GeolocationEvent.UPDATE) )
			{
				_geoLoc.removeEventListener(GeolocationEvent.UPDATE, geoUpdateHandler)
			}
			_active = false;
			_geoLoc = null;	
		}
	} 
} 
package ru.nekit.gis.view
{
	
	import com.esri.ags.events.MapEvent;
	import com.esri.ags.events.ZoomEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.WebMercatorMapPoint;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.model.proxy.UserProxy;
	import ru.nekit.gis.model.vo.PositionVO;
	import ru.nekit.gis.view.views.MapView;
	
	public class MapMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "MapMediator";
		
		private var _view:MapView;
		
		private static var mapPosition:MapPosition;
		
		[Bindable]
		[Embed(source="marker.png")]
		private var marker:Class;
		
		private var userPoi:WebMercatorMapPoint;
		private var user:UserProxy;
		
		public function MapMediator(viewComponent:Object=null)
		{
			_view = viewComponent as MapView;
			super(NAME, viewComponent);	
		}
		
		public function get view():MapView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.GPS_UPDATE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var body:Object = notification.getBody();
			var position:PositionVO = body as PositionVO;
			
			switch( notification.getName() )
			{
				
				case NAMES.GPS_UPDATE:	
					
					userPoi.lat = position.lat;
					userPoi.lon = position.lng;
					if( !userPoi )
						userPoi	= createUserPoi( position.lat, position.lng);
					_view.positionUser.visible = _view.positionUser.includeInLayout = true;
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function exitHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.EXIT);
		}
		
		private function createUserPoi(lat:Number, lng:Number ):WebMercatorMapPoint
		{
			return _view.map.addSymbol( lat, lng, new PictureMarkerSymbol(marker)).geometry as WebMercatorMapPoint;
		}
		
		private function mapComplete(event:MapEvent):void
		{
			if( user.position )
				userPoi	= createUserPoi(user.position.lat, user.position.lng);
			if( mapPosition )
				_view.map.setCenter(mapPosition.lat, mapPosition.lng, mapPosition.level);
			else
				_view.map.setCenter(43.119, 131.89, 12);
			_view.menu.visible 			= _view.menu.includeInLayout 			= true;
		}
		
		override public function onRegister():void
		{
			_view.exit.addEventListener(MouseEvent.CLICK, 				exitHandler);
			_view.map.addEventListener(MapEvent.LOAD,  					mapComplete);
			_view.minusZoom.addEventListener(MouseEvent.CLICK, 			minusHandler);
			_view.plusZoom.addEventListener(MouseEvent.CLICK, 			plusHandler);
			_view.positionUser.addEventListener(MouseEvent.CLICK, 		positionUserHandler);
			_view.map.addEventListener(ZoomEvent.ZOOM_END, zoomEndHandler);
			_view.map.addEventListener(ZoomEvent.ZOOM_START, zoomStartHandler);
			_view.positionUser.visible 	= _view.positionUser.includeInLayout 	= false;
			_view.menu.visible 			= _view.menu.includeInLayout 			= false;
			user = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			_view.map.zoomDuration = 500;
		}
		
		private function zoomStartHandler(event:ZoomEvent):void
		{
			if( event.level	<= 16 && event.level >= 10 )
			{
				_view.map.zoomDuration = 500;
			}else{
				_view.map.zoomDuration = 1;
			}
		}
		
		private function zoomEndHandler(event:ZoomEvent):void
		{
			_view.plusZoom.enabled = event.level != 16;
			_view.minusZoom.enabled = event.level != 10;
			if( event.level	> 16 )
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				event.stopPropagation();
				_view.map.zoomDuration = 1;
				_view.map.zoomOut();
			}
			else if( event.level < 10 )
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				event.stopPropagation();
				_view.map.zoomDuration = 1;
				_view.map.zoomIn();
			}
		}
		
		private function minusHandler(event:MouseEvent):void
		{
			_view.map.zoomOut();
		}
		
		private function plusHandler(event:MouseEvent):void
		{
			_view.map.zoomIn();
		}
		
		private function positionUserHandler(event:MouseEvent):void
		{
			_view.map.setCenter( user.position.lat, user.position.lng, 14);
		}
		
		override public function onRemove():void
		{
			_view.minusZoom.removeEventListener(MouseEvent.CLICK, 		minusHandler);
			_view.plusZoom.removeEventListener(MouseEvent.CLICK, 		plusHandler);
			_view.positionUser.removeEventListener(MouseEvent.CLICK, 	positionUserHandler);
			if( !mapPosition )
				mapPosition 	= new MapPosition;
			mapPosition.level	= _view.map.level;
			var point:MapPoint 	= WebMercatorUtil.webMercatorToGeographic(
				_view.map.toMapFromStage(
					(_view.map.width - _view.map.x)/2,
					(_view.map.height - _view.map.y)/2
				)
			) as MapPoint;
			mapPosition.lat 	= point.y;
			mapPosition.lng 	= point.x;
			userPoi 			= null;
			_view.map 			= null;
		}
	}
}

class MapPosition
{
	public var lat:Number;
	public var lng:Number;
	public var level:Number;
}
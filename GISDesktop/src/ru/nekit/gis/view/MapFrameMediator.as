package ru.nekit.gis.view
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.WebMercatorMapPoint;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.model.proxy.*;
	import ru.nekit.gis.model.vo.*;
	import ru.nekit.gis.view.frames.MainFrame;
	
	public class MapFrameMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "mainFrameMediator";
		
		[Bindable]
		[Embed(source="marker.png")]
		private var marker:Class;
		
		private var _owner:MainFrame;
		private var actionList:ArrayCollection;
		
		private var poi:Graphic;
		private var positionMessage:PositionMessage;
		private var position:PositionVO;
		private var sayMessage:SayMessage;
		private var joinMessage:JoinMessage;
		private var sayItem:SayVO;
		
		public function MapFrameMediator(viewComponent:Object=null)
		{
			_owner = viewComponent as MainFrame;
			_owner.map.hideInfoWindow();
			super(NAME, viewComponent);
			position = new PositionVO;
			position.lat = 43.119;
			position.lng = 131.890135;
			position.alt = 0;
			actionList = new ArrayCollection;
			_owner.listView.dataProvider = actionList;
			_owner.focusedOnUser.addEventListener(MouseEvent.CLICK, function():void
			{
				_owner.map.setCenter([position.lat, position.lng], 15);
			});
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.NET_CONNECTION_NOTIFY,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			
			switch( notification.getName() )
			{
				
				case NAMES.NET_CONNECTION_NOTIFY:
					
					var data:SendObjectVO 	= SendObjectVO(body); 
					var type:String 		= data.type;
					
					switch( type )
					{
						
						case PositionMessage.NOW:
							
							positionMessage = new PositionMessage(PositionMessage.NOW, data.body);
							position =  positionMessage.vo;
							updatePoi();	
							actionList.addItemAt( "Моя позиция: " + position + "\nTime: " + data.messageDate.toUTCString(), 0);
							
							break;
						
						case PositionMessage.HERE:
							
							positionMessage = new PositionMessage(PositionMessage.HERE, data.body);
							position =  positionMessage.vo;
							updatePoi();
							actionList.addItemAt( "Я тут:" +  position + "\nTime: " + data.messageDate.toUTCString(), 0 );
							
							break;
						
						case SayMessage.SAY:
							
							sayMessage = new SayMessage(SayMessage.SAY, data.body);
							sayItem = sayMessage.vo;
							updatePoi();
							actionList.addItemAt( "Я сказал: " + sayItem.value + "\nTime: " + data.messageDate.toUTCString(), 0);
							
							break;
						
						case SayMessage.SOS:
							
							actionList.addItemAt( "SOS" + "\nTime: " + data.messageDate.toUTCString(), 0);
							
							break;
						
						case SayMessage.STATUS:
							
							sayMessage = new SayMessage(SayMessage.SAY, data.body);
							sayItem = sayMessage.vo;
							actionList.addItemAt( "Статус: " + sayItem.value + "\nTime: " + data.messageDate.toUTCString() , 0 );
							
							break;
						
						case JoinMessage.JOIN:
							
							joinMessage = new JoinMessage(JoinMessage.JOIN);
							actionList.addItemAt( "К нам присоединился: " + data.idUser, 0 );
							
							break;
						
						default:
							break;
						
					}
					
					break;
				
				default:
					break;
				
			}
		}
		
		override public function onRegister():void
		{
			_owner.map.setCenter([position.lat, position.lng], 15);
			updatePoi();
			_owner.map.zoomDuration = 500;
		}
		
		private function updatePoi():void
		{	
			if( poi )
			{
				_owner.map.pointLayer.remove(poi);
			}
			poi = new Graphic(new WebMercatorMapPoint(position.lng, position.lat),  new PictureMarkerSymbol(marker));
			_owner.map.pointLayer.add(poi);
			poi.toolTip = (sayItem ? sayItem  : "Я" ) + "\nПозиция: " + position.toString();
		}
		
		public function get owner():MainFrame
		{
			return _owner;
		}
	}
}
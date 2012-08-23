package ru.nekit.gis.service
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.NAMES;
	import ru.nekit.gis.service.interfaces.IAccelerometerService;
	
	public class AccelerometerService extends Proxy implements IProxy, IAccelerometerService
	{
		
		public static const NAME:String = "AccelerometerModel";
		
		private var _accelerometer:Accelerometer;
		
		public function AccelerometerService()
		{
			super(NAME);
		}
		
		public function activate():void
		{
			_accelerometer = new Accelerometer;
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
		}
		
		public function deactivate():void
		{
			_accelerometer.removeEventListener(AccelerometerEvent.UPDATE, updateHandler);
			_accelerometer = null;
		}
		
		private function updateHandler(event:AccelerometerEvent):void
		{
			sendNotification(NAMES.ACCELEROMETER_UPDATE, event.accelerationY);
		}
	}
}
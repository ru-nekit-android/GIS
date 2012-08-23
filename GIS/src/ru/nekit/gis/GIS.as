package ru.nekit.gis
{
	import flash.errors.IllegalOperationError;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import ru.nekit.gis.controller.*;
	
	public class GIS extends Facade implements IFacade
	{
		
		private static var _instance:GIS;
		private static var _instanceFlag:Boolean;
		
		public static function get instance():GIS
		{
			if( !_instance )
			{
				_instanceFlag 	= true;
				_instance		= new GIS;
				_instanceFlag	= false;
			}
			return _instance;
		}
		
		public function GIS()
		{
			if( _instanceFlag )
			{
				
			}
			else
				throw new IllegalOperationError(null);
			
		}
		
		public function startup(application:Main):void
		{
			sendNotification(NAMES.STARTUP, application);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(NAMES.STARTUP, 					StartUpCommand);
			registerCommand(NAMES.ACTIVATE, 				ActivationCommand);
			registerCommand(NAMES.GPS_UPDATE, 				MessageCommand);
			registerCommand(NAMES.MESSAGE, 					MessageCommand);
			registerCommand(NAMES.NET_CONNECTION_SUCCESS, 	ConnectionSuccessCommand);			
		}
	}
}
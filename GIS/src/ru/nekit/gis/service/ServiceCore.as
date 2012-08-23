package ru.nekit.gis.service{
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	final public class ServiceCore extends EventDispatcher{
		
		private static var _instanceFlag:Boolean = false;
		private static var _instance:ServiceCore;
		
		public static const ONLINE:String 	= "online";	
		public static const OFFLINE:String 	= "offline";	
		
		private var _accessType:String = "unknown";
		
		public function ServiceCore()
		{
			if( !_instanceFlag )
			{
				throw new IllegalOperationError("ServiceCore is a singleton. Use ServiceCore.instance to obtain an instance of this class.");
			}
		}
		
		public static function get instance():ServiceCore
		{
			if( !_instance )
			{
				_instanceFlag = true;
				_instance     	= new ServiceCore;
				_instanceFlag = false;	
			}
			return _instance;
		}
		
		[Bindable(accessTypeChanged)]
		public function get isOnline():Boolean{
			return accessType == ONLINE;
		}
		
		[Bindable(accessTypeChanged)]
		public function get isOffline():Boolean{
			return accessType == OFFLINE;
		}
		
		public function set accessType(value:String):void
		{
			if( _accessType != value )
			{
				_accessType = value;
				dispatchEvent(new Event("accessTypeChanged"));
			}
		}
		
		[Bindable(accessTypeChanged)]
		public function get accessType():String
		{
			return _accessType;
		}
	}
}
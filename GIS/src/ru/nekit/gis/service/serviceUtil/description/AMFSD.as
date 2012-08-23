package ru.nekit.gis.service.serviceUtil.description{
	
	import flash.errors.IllegalOperationError;
	
	import ru.nekit.gis.service.serviceUtil.IServiceUtil;
	import ru.nekit.gis.service.serviceUtil.properties.ServiceProcessBehavior;
	
	public class AMFSD extends ServiceDescription{
		
		private static const CALL_POINT_SPLIT_SYMBOL:String 	= ".";
		private static const serviceUtilList:Array = [];
		
		public static function registerSession( serviceUtil:IServiceUtil, session:String = "main"):void
		{
			serviceUtilList[session] = serviceUtil;
		}
		
		public static function getSession(session:String = "main"):IServiceUtil
		{
			return IServiceUtil(serviceUtilList[session]);
		}
		
		public static function destroySession(session:String = "main"):void
		{
			IServiceUtil(serviceUtilList[session]).close();
			delete serviceUtilList[session];
		}
		
		public function AMFSD(className:String, functionName:String, ...parameters)
		{
			super(className + CALL_POINT_SPLIT_SYMBOL + functionName, parameters);
		}
		
		public static function callPoint(name:String):AMFCallPoint
		{
			return new AMFCallPoint(name.substring(0, name.lastIndexOf(CALL_POINT_SPLIT_SYMBOL)), name.substring(name.lastIndexOf(CALL_POINT_SPLIT_SYMBOL) + CALL_POINT_SPLIT_SYMBOL.length));
		}
		
		override public function execute(processBehavior:ServiceProcessBehavior = null, session:String = "main"):void
		{
			var serviceUtil:IServiceUtil = IServiceUtil(serviceUtilList[session]);
			if( !serviceUtil ){
				throw new IllegalOperationError("serviceUtil is not set!");
			}
			serviceUtil.call(this, processBehavior);
		}
	}
}

class AMFCallPoint{
	
	public var className:String;
	public var functionName:String;
	function AMFCallPoint(className:String, functionName:String)
	{
		this.className    = className;
		this.functionName = functionName;
	}
	
}
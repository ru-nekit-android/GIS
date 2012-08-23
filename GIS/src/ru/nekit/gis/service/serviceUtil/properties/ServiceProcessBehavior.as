package ru.nekit.gis.service.serviceUtil.properties{
	
	public class ServiceProcessBehavior{
		
		public static const RESEND_ALWAYS:String 	= "always";
		public static const RESEND_FAULT:String 	= "fault";
		
		public var internalData:Object;
		public var resultFunction:Function;
		public var faultFunction:Function;
		public var resendable:String;
		public var resendWait:Number;
		
		public function ServiceProcessBehavior(internalData:Object = null, resultFunction:Function = null, faultFunction:Function = null, resendable:String = RESEND_FAULT, resendWait:Number = 0)
		{
			this.internalData  	 	= internalData;
			this.resultFunction 	= resultFunction;
			this.faultFunction  		= faultFunction;
			this.resendable 			= resendable;
			this.resendWait         = resendWait;
		}
		
		public static function withFunctions(result:Function, fault:Function = null, internalData:Object = null):ServiceProcessBehavior{
			return new ServiceProcessBehavior( internalData, result, fault, null);
		}
		
		public static function withFunctionsAndResendable(result:Function, fault:Function = null, internalData:Object = null, type:String = RESEND_FAULT,  resendWait:Number = 0):ServiceProcessBehavior
		{
			return new ServiceProcessBehavior(internalData, result, fault, type, resendWait);
		}
		
		public static function resendable(type:String = RESEND_FAULT,  resendWait:Number = 0):ServiceProcessBehavior
		{
			return new ServiceProcessBehavior(null, null, null, type, resendWait);
		}
	}
}
package ru.nekit.gis.service.serviceUtil.description{
	
	import flash.errors.IllegalOperationError;
	
	import ru.nekit.gis.service.serviceUtil.properties.ServiceProcessBehavior;

	
	public class ServiceDescription{
		
		public var callPoint:String;
		public var parameters:*;
		
		public function ServiceDescription(callPoint:String, parameters:*){
			this.callPoint        = callPoint;
			this.parameters    = parameters;	
		}
		
		public function execute(processBehavior:ServiceProcessBehavior = null, session:String = null):void{
			throw new IllegalOperationError("You must override this function.");
		}
	}
}
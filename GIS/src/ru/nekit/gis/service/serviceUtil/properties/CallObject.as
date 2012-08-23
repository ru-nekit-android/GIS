package ru.nekit.gis.service.serviceUtil.properties{

	import flash.events.EventDispatcher;
	
	import ru.nekit.gis.service.serviceUtil.description.ServiceDescription;

	public class CallObject extends EventDispatcher{
		
		public var serviceDescription:ServiceDescription;
		public var processBehavior:ServiceProcessBehavior;
		
		public function CallObject(serviceDescription:ServiceDescription, processBehavior:ServiceProcessBehavior)
		{
			this.serviceDescription = serviceDescription;
			this.processBehavior    	= processBehavior;
		}
	}
}
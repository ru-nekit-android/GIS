package  ru.nekit.gis.service.serviceUtil{
	
	import ru.nekit.gis.service.serviceUtil.description.ServiceDescription;
	import ru.nekit.gis.service.serviceUtil.properties.CallObject;
	import ru.nekit.gis.service.serviceUtil.properties.ServiceProcessBehavior;
	
	public interface IServiceUtil{
		function call(serviceDescription:ServiceDescription, processBehavior:ServiceProcessBehavior = null):Boolean;	
		function close():void;	
		function resend():void;	
		function get callObject():CallObject;
	}
}
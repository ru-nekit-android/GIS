package ru.nekit.gis.service.interfaces
{
	import org.puremvc.as3.interfaces.IProxy;
	
	public interface IConnectionDetectService
	{
		
		function get active():Boolean;
		function get macAddress():String;
	}
}
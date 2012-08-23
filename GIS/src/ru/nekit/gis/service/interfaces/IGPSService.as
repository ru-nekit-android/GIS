package ru.nekit.gis.service.interfaces
{
	import ru.nekit.gis.model.vo.PositionVO;

	public interface IGPSService
	{
		
		function set refreshInterval(value:Number):void;
		function get refreshInterval():Number;
		function get currentLatLng():PositionVO;
		function get support():Boolean;
		function activate():void;
		function get active():Boolean;
		function deactivate():void;
		
	}
}
package ru.nekit.gis.service.interfaces
{
	public interface INetConnectionService
	{
		
		function activate():void;
		function get connected():Boolean;
		function send(message:*):Boolean;
		
	}
}
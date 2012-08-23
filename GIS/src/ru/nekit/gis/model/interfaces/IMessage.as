package ru.nekit.gis.model.interfaces
{
	
	public interface IMessage extends ISerialize, IDeserialize
	{
		
		function get name():String;
		
	}
}
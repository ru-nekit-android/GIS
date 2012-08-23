package ru.nekit.gis.model.interfaces
{
	import flash.utils.ByteArray;

	public interface IDeserialize
	{
		
		function deserialize(value:ByteArray):void;
		
	}
}
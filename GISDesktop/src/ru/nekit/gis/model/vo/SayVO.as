package ru.nekit.gis.model.vo
{
	
	[Bindable]
	[RemoteClass]
	public class SayVO
	{
		
		public var value:String;
		
		public function toString():String
		{
			return value;
		}
	}
}
package ru.nekit.gis.model.vo
{
	
	[Bindable]
	[RemoteClass]
	public class SayVO
	{
		
		public var value:String;
		
		public function SayVO(value:String)
		{
			this.value = value;
		}
		
		public function toString():String
		{
			return value;
		}
	}
}
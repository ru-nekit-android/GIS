package ru.nekit.gis.model.vo
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass]
	public class SendObjectVO
	{
		
		public var idUser:String;
		public var id:uint;
		public var type:String;
		public var body:ByteArray;
		public var sendDate:Date;
		public var messageDate:Date;
		
	}
}
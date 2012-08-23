package ru.nekit.gis.model.vo
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[RemoteClass]
	public class SendObjectVO
	{
		private static var ID:uint = 0;
		
		public var idUser:String;
		public var id:uint;
		public var type:String;
		public var body:ByteArray;
		public var sendDate:Date;
		public var messageDate:Date;
		
		public function SendObjectVO(idUser:String, type:String, body:ByteArray = null, messageDate:Date = null)
		{
			
			this.idUser			= idUser;
			this.id 			= ID++;
			this.type 			= type;
			this.body			= body;
			this.messageDate	= messageDate ? messageDate : new Date;
			this.sendDate 		= new Date;
		}
	}
}
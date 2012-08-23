package ru.nekit.gis.model.vo
{
	import flash.utils.ByteArray;
	
	import ru.nekit.gis.manager.entity.StorageEntity;
	import ru.nekit.gis.model.interfaces.ISerialize;
	
	[Bindable]
	[Table("messageList")]
	public class HistoryMessageVO extends StorageEntity
	{
		
		public var type:String;
		public var body:ByteArray;
		
		public function HistoryMessageVO(type:String = null, item:ISerialize = null)
		{
			this.type = type;
			if( item )
				this.body = item.serialize;
		}
	}
}
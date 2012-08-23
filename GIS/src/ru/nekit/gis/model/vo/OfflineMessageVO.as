package ru.nekit.gis.model.vo
{
	import flash.utils.ByteArray;
	
	import ru.nekit.gis.manager.entity.StorageEntity;
	import ru.nekit.gis.model.interfaces.ISerialize;
	
	[Bindable]
	[Table("offlineMessageList")]
	public class OfflineMessageVO extends StorageEntity
	{
		
		public var type:String;
		public var date:Date;
		public var body:ByteArray;
		
		public function OfflineMessageVO(type:String = null, item:ISerialize = null)
		{
			this.type = type;
			this.date = new Date;
			if( item )
				this.body = item.serialize;
		}
	}
}
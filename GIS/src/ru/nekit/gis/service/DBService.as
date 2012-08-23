package ru.nekit.gis.service
{
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import ru.nekit.gis.manager.entity.EntityManager;
	import ru.nekit.gis.manager.entity.IEntity;
	import ru.nekit.gis.service.interfaces.IDBService;
	
	public class DBService extends Proxy implements IProxy, IDBService
	{
		
		public static const NAME:String = "db";
		
		private const em:EntityManager = EntityManager.instance;
		private var _dbFile:File;
		private var _connection:SQLConnection;	
		
		public function DBService()
		{
			super(NAME);
		}
		
		public function createDatabase():void
		{
			_dbFile = File.applicationStorageDirectory.resolvePath("gis.db");
			_connection 		= new SQLConnection();
			_connection.open(_dbFile);
			em.sqlConnection 	= _connection;
		}
		
		public function deleteDatabase():Boolean
		{
			var result:Boolean = false;
			if ( _dbFile ) 
			{				
				if ( _connection && _connection.connected )
					_connection.close(null);	
				var fs:FileStream = new FileStream();
				try 
				{
					fs.open(_dbFile,FileMode.UPDATE);
					while ( fs.bytesAvailable )	
						fs.writeByte(Math.random() * Math.pow(2,32));						
					fs.close();
					this._dbFile.deleteFile();				
					result = true;
				}
				catch (e:Error)
				{
					fs.close();
				}				
			}
			return result;
		}
		
		public function save(o:IEntity):IEntity
		{
			em.save(o);
			return o;
		}
		
		public function create(c:Class):void
		{
			em.create(c);
		}
		
		public function drop(c:Class):void
		{
			em.drop(c);
		}
		
		public function remove(o:IEntity):void
		{
			em.remove(o);
		}
		
		public function removeAll(c:Class):void
		{
			em.removeAll(c);
		}
		
		public function select(o:IEntity):Vector.<IEntity>
		{
			return em.select(o);
		}
		
		public function selectAll(c:Class):Vector.<IEntity>
		{
			return em.selectAll(c);
		}
	}
}
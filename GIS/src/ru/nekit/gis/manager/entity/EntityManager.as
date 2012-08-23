package ru.nekit.gis.manager.entity
{
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	
	public class EntityManager{
		
		private static var _instance:EntityManager;        
		private static var localInstantiation:Boolean = false;
		
		private var _metadataMap:Vector.<EntityItemInfo> = new Vector.<EntityItemInfo>;
		private var _metadataIndex:Array = new Array;
		private var _sqlConnection:SQLConnection;
		
		public var dataBaseName:String;
		
		public function EntityManager()
		{
			if (!localInstantiation)
			{
				throw new IllegalOperationError("EntityManager is a singleton. Use EntityManager.instance to obtain an instance of this class.");
			}
		}
		
		public static function get instance():EntityManager
		{
			if (!_instance)
			{
				localInstantiation = true;
				_instance = new EntityManager;
				localInstantiation = false;
			}
			return _instance;
		}
		
		private function metadataMap(c:Class):EntityItemInfo{
			if( _metadataIndex[c] )
			{
				return _metadataMap[int(_metadataIndex[c]) - 1];
			}
			return null;
		}
		
		public function selectAll(c:Class):Vector.<IEntity>
		{
			if (!metadataMap(c)) loadMetadata(c);
			var stmt:SQLStatement = metadataMap(c).selectAllStmt;
			stmt.execute();
			stmt.itemClass = c;
			var result:Array = stmt.getResult().data;
			return typeArray(result, c);
		}
		
		public function save(o:IEntity):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			var identity:Object = metadataMap(c).identity;
			if (o[identity.field]>0)
			{
				updateItem(o,c);
			}
			else
			{
				createItem(o,c);
			}
		}
		
		public function drop(c:Class):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			var stmt:SQLStatement = metadataMap(c).dropStmt;
			stmt.execute();
		}
		
		private function updateItem(o:IEntity, c:Class):void
		{	
			var stmt:SQLStatement = metadataMap(c).updateStmt;
			var fields:ArrayCollection = metadataMap(c).fields;
			var exludeFields:Array = new Array;
			for (var i:int = 0; i<fields.length; i++)
			{
				var field:String = fields.getItemAt(i).field;
				stmt.parameters[":" + field] = o[field];
			}
			stmt.execute();
		}
		
		public function create(c:Class):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			var stmt:SQLStatement = metadataMap(c).createStmt;
			stmt.execute();
		}
		
		private function createItem(o:IEntity, c:Class):void
		{
			var stmt:SQLStatement = metadataMap(c).insertStmt;
			var identity:Object = metadataMap(c).identity;
			var fields:ArrayCollection = metadataMap(c).fields;
			for (var i:int = 0; i<fields.length; i++)
			{
				var field:String = fields.getItemAt(i).field;
				if (field != identity.field)
				{
					stmt.parameters[":" + field] = o[field];
				}
			}
			stmt.execute();
			o[identity.field] = stmt.getResult().lastInsertRowID;
		}
		
		public function remove(o:IEntity):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			var identity:Object = metadataMap(c).identity;
			var stmt:SQLStatement = metadataMap(c).deleteStmt;
			stmt.parameters[":"+identity.field] = o[identity.field];
			stmt.execute();
		}
		
		public function removeAll(c:Class):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			var stmt:SQLStatement =  metadataMap(c).deleteAllStmt;
			stmt.execute();
		}
		
		public function select(o:IEntity):Vector.<IEntity>
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			var identity:EntityField = metadataMap(c).identity;
			var stmt:SQLStatement = metadataMap(c).selectStmt;
			stmt.parameters[":"+identity.field] = o[identity.field];
			stmt.execute();
			var result:Array = stmt.getResult().data;
			return typeArray(result, c);
		}
		
		private function loadMetadata(c:Class):void
		{
			_metadataMap.push(new EntityItemInfo);
			_metadataIndex[c] = _metadataMap.length;
			var xml:XML = describeType(new c());
			var table:String = xml.metadata.(@name=="Table").arg.(@key=="").@value;
			if( dataBaseName )
				table = dataBaseName+ "." + table;
			metadataMap(c).table = table;
			metadataMap(c).fields = new ArrayCollection();
			var variables:XMLList = xml.accessor;
			
			var insertParams:String = "";
			var updateSQL:String = "UPDATE " + table + " SET ";
			var insertSQL:String = "INSERT INTO " + table + " (";
			var createSQL:String = "CREATE TABLE IF NOT EXISTS " + table + " (";
			var selectSQL:String = "SELECT * FROM " + table;
			
			for (var i:int = 0 ; i < variables.length() ; i++) 
			{
				var field:String = variables[i].@name.toString();
				var column:String;        
				var columnXML:XMLList = variables[i].metadata;
				var hasColumn:Boolean;
				try
				{
					hasColumn = columnXML.(@name=="Column").length() > 0;
				}catch(error:Error){
				}
				if ( hasColumn )
					column = variables[i].metadata.(@name=="Column").arg.(@key=="").@value.toString();
				else
				{
					var isExclude:Boolean;
					try
					{
						isExclude = variables[i].metadata.(@name=="Exclude").length() > 0;
					}catch(error:Error){	
					}
					if ( isExclude )
					{
						continue;
					}
					else
					{
						column = field;
					}
				}
				metadataMap(c).fields.addItem( new EntityField(field, column) );
				var isId:Boolean;
				try
				{
					isId = variables[i].metadata.(@name=="Id").length() > 0;
				}catch(error:Error){	
				}
				if ( isId )
				{
					metadataMap(c).identity = new EntityField(field, column);
					createSQL += column + " INTEGER PRIMARY KEY AUTOINCREMENT,";
				}
				else                
				{
					insertSQL += column + ",";
					insertParams += ":" + field + ",";
					updateSQL += column + "=:" + field + ",";
					createSQL += column + " " + getSQLType(variables[i].@type) + ",";
				}
			}
			if( !metadataMap(c).identity )
			{
				try{
					field = xml.variable.@name.toString();
					isId = xml.variable.metadata.(@name=="Id").length() > 0;
					if( isId )
					{
						hasColumn = xml.variable.metadata.(@name=="Colimn").length() > 0;
						column = hasColumn ?  xml.variable.metadata.(@name=="Column").arg.(@key=="").@value.toString() : field
						metadataMap(c).fields.addItem( new EntityField(field, column) );
					}
				}catch(error:Error){	
				}
				if ( isId )
				{
					metadataMap(c).identity = new EntityField(field, column);
					createSQL += column + " INTEGER PRIMARY KEY AUTOINCREMENT,";
				}
			}
			
			createSQL = createSQL.substring(0, createSQL.length-1) + ")";
			insertSQL = insertSQL.substring(0, insertSQL.length-1) + ") VALUES (" + insertParams;
			insertSQL = insertSQL.substring(0, insertSQL.length-1) + ")";
			updateSQL = updateSQL.substring(0, updateSQL.length-1);
			updateSQL += " WHERE " + metadataMap(c).identity.column + "=:" + metadataMap(c).identity.field;
			selectSQL += " WHERE " + metadataMap(c).identity.column + "=:" + metadataMap(c).identity.field;
			var deleteSQL:String = "DELETE FROM " + table + " WHERE " + metadataMap(c).identity.column + "=:" + metadataMap(c).identity.field;
			
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = insertSQL;
			metadataMap(c).insertStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = updateSQL;
			metadataMap(c).updateStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = deleteSQL;
			metadataMap(c).deleteStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "SELECT * FROM " + table;
			metadataMap(c).selectAllStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = selectSQL;
			metadataMap(c).selectStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "DROP TABLE " + table;
			metadataMap(c).dropStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = createSQL;
			metadataMap(c).createStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "DELETE FROM " + table;
			metadataMap(c).deleteAllStmt = stmt;
		}
		
		private function typeArray(a:Array, c:Class):Vector.<IEntity>
		{
			if (a==null) return null;
			var v:Vector.<IEntity> = new Vector.<IEntity>;
			const length:uint = a.length;
			for (var i:int=0; i<length; i++)
			{
				v.push(typeObject(a[i],c));
			}
			return v;            
		}
		
		private function typeObject(o:Object, c:Class):Object
		{
			var instance:Object = new c();
			var fields:ArrayCollection = metadataMap(c).fields;
			
			for (var i:int; i<fields.length; i++)
			{
				var item:Object = fields.getItemAt(i);
				instance[item.field] = o[item.column];    
			}
			return instance;
		}
		
		private function getSQLType(asType:String):String
		{
			if (asType == "int" || asType == "uint")
				return "INTEGER";
			else if (asType == "Number")
				return "REAL";
			else if( asType == "Date")
				return "DATETIME";
			else if (asType == "flash.utils::ByteArray" || asType == "Object" )
				return "BLOB";
			else
				return "TEXT";                
		}
		
		public function set sqlConnection(sqlConnection:SQLConnection):void
		{
			_sqlConnection = sqlConnection;
		}
		
		public function get sqlConnection():SQLConnection
		{
			return _sqlConnection;
		}
	}
}

import flash.data.SQLStatement;

import mx.collections.ArrayCollection;

class EntityItemInfo{
	
	public var table:String;
	public var fields:ArrayCollection;
	public var identity:EntityField;
	public var insertStmt:SQLStatement;
	public var updateStmt:SQLStatement;
	public var deleteStmt:SQLStatement;
	public var deleteAllStmt:SQLStatement;
	public var selectAllStmt:SQLStatement;
	public var selectStmt:SQLStatement;
	public var createStmt:SQLStatement;
	public var dropStmt:SQLStatement;
}

class EntityField{
	
	public function EntityField(field:String, column:String)
	{
		this.field 			= field;
		this.column 	= column;
	}
	
	public var field:String;
	public var column:String;
	
}
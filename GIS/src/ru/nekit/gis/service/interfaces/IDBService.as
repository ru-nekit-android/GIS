package ru.nekit.gis.service.interfaces
{
	
	import ru.nekit.gis.manager.entity.IEntity;
	
	public interface IDBService
	{
		
		function selectAll(c:Class):Vector.<IEntity>;
		function save(o:IEntity):IEntity;
		function create(c:Class):void;
		function remove(o:IEntity):void;
		function removeAll(c:Class):void;
		function drop(c:Class):void;
		function select(o:IEntity):Vector.<IEntity>;
		function createDatabase():void;
		function deleteDatabase():Boolean;
		
	}
}
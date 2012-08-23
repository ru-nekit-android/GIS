package ru.nekit.gis.service.serviceCommand{
	
	import ru.nekit.gis.service.serviceUtil.description.AMFSD;
	
	public final class MissionSC{
		
		public static const CLASS:String 							= "MissionService";
		public static const GET:String 								= "getMissionByCode";
		public static const GET_BY_ID:String 						= "getMissionById";
		public static const GET_FIRST_MISSION:String 				= "getFirstMission";
		
		public static function getByCode(code:String):AMFSD
		{
			return new AMFSD(CLASS, GET, code);
		}
		
		public static function getById(id:int):AMFSD
		{
			return new AMFSD(CLASS, GET_BY_ID, id);
		}
		
		public static function get firstMission():AMFSD
		{
			return new AMFSD(CLASS, GET_FIRST_MISSION);
		}
	}
}
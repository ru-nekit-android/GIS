package ru.nekit.gis.model.map.layer
{
	import com.esri.ags.layers.OpenStreetMapLayer;
	
	import flash.net.URLRequest;
	
	public class MapQuestLayer extends OpenStreetMapLayer
	{
		
		override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
		{
			return new URLRequest(  "http://vtiles01.mqcdn.com/tiles/1.0.0/map/" + level + "/" + col + "/" + row + ".png"  );
		}
	}
}
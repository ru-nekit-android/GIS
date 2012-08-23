package ru.nekit.gis.model.map.layer
{
	import com.esri.ags.layers.OpenStreetMapLayer;
	
	import flash.net.URLRequest;
	
	public class OfflineOpenStreetMapLayer extends OpenStreetMapLayer
	{
		
		override protected function  getTileURL(level:Number, row:Number, col:Number):URLRequest
		{
			return new URLRequest("map/" + level + "/" + col + "/" + row + ".png");
		}
	}
}
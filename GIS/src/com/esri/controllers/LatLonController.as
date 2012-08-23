package com.esri.controllers
{
	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.geometry.WebMercatorMapPoint;
	import com.esri.ags.symbols.Symbol;
	import com.esri.model.Model;
	
	public final class LatLonController
	{
		[Bindable]
		public var model:Model;
		
		public function addSymbol(lat:Number, lon:Number, symbol:Symbol = null, toolTip:String = null ):Graphic
		{
			const feature:Graphic = new Graphic(new WebMercatorMapPoint(lon, lat), symbol);
			if( !toolTip )
				feature.toolTip = lat.toFixed(6) + '\n' + lon.toFixed(6);
			else
				feature.toolTip = toolTip;
			model.pointArrCol.addItem(feature);
			return feature;
		}
		
		public function addLine(points:Array, symbol:Symbol = null):Graphic
		{
			const feature:Graphic = new Graphic(new Polyline([ toMercator(points)]), symbol);
			model.polylineArrCol.addItem(feature);
			return feature;
		}
		
		public function addPolygon(points:Array, symbol:Symbol = null):Graphic
		{
			const feature:Graphic = new Graphic(new Polygon([ toMercator(points)]), symbol);
			model.polylineArrCol.addItem(feature);
			return feature;
		}
		
		private function toMercator(orig:Array):Array
		{
			const dest:Array = [];
			for each (var obj:Object in orig)
			{
				const mapPoint:MapPoint = obj as MapPoint;
				if (mapPoint)
				{
					dest.push(toMercatorPoint(mapPoint));
					continue;
				}
				const arr:Array = obj as Array;
				if (arr)
				{
					const lat:Number = arr[0];
					const lon:Number = arr[1];
					dest.push(new WebMercatorMapPoint(lon, lat));
				}
			}
			return dest;
		}
		
		private function toMercatorPoint(mapPoint:MapPoint):MapPoint
		{
			if (mapPoint.x >= -180.0 && mapPoint.x <= 180.0 && mapPoint.y >= -90 && mapPoint.y <= 90)
			{
				return new WebMercatorMapPoint(mapPoint.x, mapPoint.y);
			}
			return mapPoint;
		}
	}
}

package ru.nekit.gis.model.vo
{
	[Bindable]
	[RemoteClass]
	public class PositionVO
	{
		
		public var lat:Number;
		public var lng:Number;
		public var alt:Number;
		public var horizontalAccuracy:Number;
		public var verticalAccuracy:Number;
		
		public function toString():String
		{
			return "lat: " + lat.toFixed(3) + " | " + "lng: " + lng.toFixed(3) + " | " + "alt: " + alt.toFixed(3);
		}
	}
}
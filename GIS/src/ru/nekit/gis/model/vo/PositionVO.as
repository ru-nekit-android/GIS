package ru.nekit.gis.model.vo
{
	
	[Bindable]
	[RemoteClass]
	public class PositionVO 
	{
		
		public var lat:Number = 0;
		public var lng:Number = 0;
		public var alt:Number;
		public var horizontalAccuracy:Number;
		public var verticalAccuracy:Number;
		
		public function PositionVO(lat:Number = 0, lng:Number = 0, alt:Number = 0, horizontalAccuracy:Number = 0, verticalAccuracy:Number = 0)
		{
			this.lat = lat;
			this.lng = lng;
			this.alt = alt;
			this.horizontalAccuracy = horizontalAccuracy;
			this.verticalAccuracy  	= verticalAccuracy;
		}
		
		public function toString():String
		{
			return "[ lat: " + lat.toFixed(3) + " | lng: " + lng.toFixed(3) + " | alt: " + alt.toFixed(3) +" ]";
		}
		
	}
}
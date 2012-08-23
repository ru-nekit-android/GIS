package ru.nekit.gis.service.serviceUtil{
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	import ru.nekit.gis.service.events.ServiceEvent;
	import ru.nekit.gis.service.serviceUtil.description.ServiceDescription;
	import ru.nekit.gis.service.serviceUtil.properties.CallObject;
	import ru.nekit.gis.service.serviceUtil.properties.ServiceProcessBehavior;
	import ru.nekit.gis.service.serviceUtil.result.ServiceUtilResult;
	//import util.gc.GC;
	
	[Event(name="success",   			type="ru.nekit.kb.events.ServiceEvent")]
	[Event(name="failed",   				type="ru.nekit.kb.events.ServiceEvent")]
	final public class AMFServiceUtil extends ServiceUtil implements IServiceUtil{
		
		public static var MAX_EXECUTE_TIME:uint = 30;
		private static var netConnection:NetConnection = new NetConnection;	 
		
		public static function isConnectionFailed(result:ServiceUtilResult):Boolean
		{
			return  result.error && "code" in result.error && result.error.code == "NetConnection.Call.Failed";
		}
		
		private var timer:Timer = new Timer(MAX_EXECUTE_TIME*1000);
		private var faultCount:uint;
		private var responder:Responder;
		
		public var gateway:String     = "http://localhost/amfphp/gateway.php";
		
		public function AMFServiceUtil(gateway:String)
		{
			netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 			asynErrorHandler);
			netConnection.addEventListener(IOErrorEvent.IO_ERROR, 						ioErrorHandler);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	secureErrorHandler);
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, 				statusHandler);
			this.gateway 	= gateway;
			netConnection.connect( gateway);
			stack  				= new ArrayCollection;
			responder     	= new Responder(onResult, onFault);	
			timer.addEventListener(TimerEvent.TIMER, 											timeComplete);
		}
		
		private function timeComplete(event:TimerEvent):void
		{	
			timer.stop();
			if( _callObject.processBehavior.resendable == ServiceProcessBehavior.RESEND_FAULT || _callObject.processBehavior.resendable == ServiceProcessBehavior.RESEND_ALWAYS )
			{
				resend();
			}
			else
			{
				callFault(new ServiceUtilResult(null, new Error("Out of time"), this));
			}
		}
		
		override public function call(serviceDescription:ServiceDescription, processBehavior:ServiceProcessBehavior = null ):Boolean
		{
			if( !processBehavior )
			{
				processBehavior = new ServiceProcessBehavior();
			}
			var canSend:Boolean       		= stack.length == 0;	
			var sendObject:CallObject 	= new CallObject(serviceDescription, processBehavior);
			stack.addItem(sendObject);
			if(canSend)
			{
				_callObject = sendObject;
				_call(serviceDescription.callPoint, serviceDescription.parameters);		
			}	
			return canSend; 	
		}
		
		private  function onFault(status:Object):void
		{
			var result:ServiceUtilResult = new ServiceUtilResult(null, status.description, this);
			dispatchEvent(new ServiceEvent(ServiceEvent.FAILED, result));
			callFault(result);
		}
		
		override protected function _call(name:String = null, parameters:* = null):void
		{
			//if( !netConnection.connected )
			//{
			//	netConnection.connect( gateway);
			//	}
			var callFunction:Function = netConnection.call;
			var arg:Array = new Array;
			arg.push(name);
			arg.push(responder);
			if( parameters )
			{
				const length:uint = parameters.length;
				for(var i:int = 0; i < length; i++)
				{
					arg.push(parameters[i]);	
				}
			}
			callFunction.apply(callFunction, arg);
			timer.start();
		}
		
		override public function close():void
		{
			super.close();
			_callObject = null;
			stack.removeAll();
			netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, 				asynErrorHandler);
			netConnection.removeEventListener(IOErrorEvent.IO_ERROR, 							ioErrorHandler);
			netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	secureErrorHandler);
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, 					statusHandler);
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, 													timeComplete);
			timer = null;
		}
		
		private function onResult(result:Object):void
		{
			super.callResult(new ServiceUtilResult(result, null, this));
			if( timer )
			{
				timer.stop();
			}
		}
		
		override protected function callFault(result:ServiceUtilResult):void
		{		
			if( isConnectionFailed(result) )
			{
				if( faultCount > 1000 )
				{
					faultCount = 0;
					System.gc();
				}
				faultCount++;
			}
			super.callFault(result);
			if( timer )
			{
				timer.stop();
			}
		}
		
		private function asynErrorHandler(error:AsyncErrorEvent):void
		{
			var result:ServiceUtilResult = new ServiceUtilResult(null, error, this);
			dispatchEvent(new ServiceEvent(ServiceEvent.FAILED, result));
			callFault(result);
		}
		
		private function ioErrorHandler(error:IOErrorEvent):void
		{
			var result:ServiceUtilResult = new ServiceUtilResult(null, error,this);
			dispatchEvent(new ServiceEvent(ServiceEvent.FAILED, result));
			callFault(result);
		}
		
		private function secureErrorHandler(error:SecurityErrorEvent):void
		{
			var result:ServiceUtilResult = new ServiceUtilResult(null, error, this);
			dispatchEvent(new ServiceEvent(ServiceEvent.FAILED, result));
			callFault(result);
		}
		
		private function statusHandler(event:NetStatusEvent):void
		{
			if( _callObject )
			{
				if( event.info.level == "error")
				{
					var result:ServiceUtilResult = new ServiceUtilResult(null, event.info, this);
					dispatchEvent(new ServiceEvent(ServiceEvent.FAILED, result));
					callFault(result);
				}
				else if( event.info.level == "status" )
				{
					if( event.info.code == "NetConnection.Connect.Closed" )
					{
						var timeOut:uint = setTimeout(function():void{netConnection.connect(gateway);clearTimeout(timeOut);}, 300);
					}
				}
			}
		}	
	}
}
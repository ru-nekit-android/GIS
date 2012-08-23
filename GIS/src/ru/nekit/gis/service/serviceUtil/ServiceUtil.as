package ru.nekit.gis.service.serviceUtil{
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import ru.nekit.gis.service.events.ServiceEvent;
	import ru.nekit.gis.service.serviceUtil.description.ServiceDescription;
	import ru.nekit.gis.service.serviceUtil.properties.CallObject;
	import ru.nekit.gis.service.serviceUtil.properties.ServiceProcessBehavior;
	import ru.nekit.gis.service.serviceUtil.result.ServiceUtilResult;
	
	public class ServiceUtil extends EventDispatcher implements IServiceUtil{
		
		protected var stack:ArrayCollection;
		protected var _callObject:CallObject;
		protected var resendWaitTimer:Timer;
		
		public function get callStack():ArrayCollection
		{
			return stack;
		}
		
		public function get callObject():CallObject
		{
			return _callObject;
		}
		
		protected  function callResult(result:ServiceUtilResult):void
		{
			if( !_callObject ) return;
			var event:ServiceEvent;
			dispatchEvent(event = new ServiceEvent(ServiceEvent.SUCCESS, result));
			if( !event || !event.isDefaultPrevented() )
			{
				if( _callObject.processBehavior.resultFunction != null )
				{
					result.serviceUtil = this;
					_callObject.processBehavior.resultFunction.call(_callObject.processBehavior.resultFunction, result);
				}
			}
			if( _callObject )
			{
				if(  _callObject.processBehavior.resendable == ServiceProcessBehavior.RESEND_ALWAYS )
				{
					resend();
				}
				else
				{
					removeSession();
				}
			}
		}
		
		protected function callFault(result:ServiceUtilResult):void
		{
			if( !_callObject ) return;
			var event:ServiceEvent;
			dispatchEvent(event = new ServiceEvent(ServiceEvent.FAILED, result));
			if( !event || !event.isDefaultPrevented() )
			{
				if( _callObject.processBehavior.faultFunction != null )
				{
					result.serviceUtil = this;
					_callObject.processBehavior.faultFunction.call(_callObject.processBehavior.faultFunction, result);
				}
			}
			if( _callObject )
			{
				if( _callObject.processBehavior.resendable == ServiceProcessBehavior.RESEND_FAULT || _callObject.processBehavior.resendable == ServiceProcessBehavior.RESEND_ALWAYS )
				{
					resend();
				}
				else
				{
					removeSession();
				}
			}
		}
		
		protected function removeSession():void
		{
			if( stack && stack.length > 0)
			{
				stack.removeItemAt(0);
				if(stack.length > 0)
				{
					_callObject = CallObject(stack.getItemAt(0));
					_call(_callObject.serviceDescription.callPoint, _callObject.serviceDescription.parameters);
				}
			}
		}
		
		protected function _call(name:String = null, parameters:* = null):void
		{
			throw new IllegalOperationError("You must override this function.");
		}
		
		public function call(serviceDescription:ServiceDescription, processBehavior:ServiceProcessBehavior = null):Boolean
		{
			throw new IllegalOperationError("You must override this function.");
		}
		
		public function close():void
		{
			if( resendWaitTimer)
			{
				resendWaitTimer.stop();
				resendWaitTimer.removeEventListener(TimerEvent.TIMER, resendTimerComplete);
			}
		}
		
		private function resendTimerComplete(event:TimerEvent):void
		{
			resendWaitTimer.stop();
			_call(_callObject.serviceDescription.callPoint, _callObject.serviceDescription.parameters);
		}
		
		final public function resend():void
		{
			if( _callObject )
			{
				if( _callObject.processBehavior.resendWait != 0 )
				{
					resendWaitTimer = new Timer( _callObject.processBehavior.resendWait );
					resendWaitTimer.addEventListener(TimerEvent.TIMER, resendTimerComplete);
					resendWaitTimer.start();
				}
				else
				{
					call(_callObject.serviceDescription, _callObject.serviceDescription.parameters);
				}
			}
		}
	}
}
package artcustomer.game.minesweeper.core.game.timer {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import artcustomer.maxima.base.IDestroyable;
	
	import artcustomer.game.minesweeper.events.GameTimerEvent;
	
	[Event(name="onTick", type="artcustomer.game.minesweeper.events.GameTimerEvent")]
	[Event(name="onTimeLimit", type="artcustomer.game.minesweeper.events.GameTimerEvent")]
	
	
	/**
	 * GameTimer
	 * 
	 * @author David Massenot
	 */
	public class GameTimer extends EventDispatcher implements IDestroyable {
		private var _delayTime:int;
		private var _maxTime:int;
		
		private var _timer:Timer;
		
		private var _tick:int;
		
		private var _isOnStart:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * @param	delay : Delay in milliseconds.
		 * @param	max : Time limit in milliseconds.
		 */
		public function GameTimer(delay:int = 1000, max:int = 600000) {
			_delayTime = delay;
			_maxTime = max;
			
			setupTimer();
			
			_isOnStart = false;
		}
		
		//---------------------------------------------------------------------
		//  Values
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function resetValues():void {
			_tick = 0;
		}
		
		//---------------------------------------------------------------------
		//  Timer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTimer():void {
			_timer = new Timer(_delayTime, _maxTime / _delayTime);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
		}
		
		/**
		 * @private
		 */
		private function startTimer():void {
			_timer.start();
		}
		
		/**
		 * @private
		 */
		private function stopTimer():void {
			_timer.reset();
		}
		
		/**
		 * @private
		 */
		private function destroyTimer():void {
			_timer.removeEventListener(TimerEvent.TIMER, handleTimer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
			_timer.reset();
			_timer = null;
		}
		
		/**
		 * @private
		 */
		private function handleTimer(e:TimerEvent):void {
			switch (e.type) {
				case(TimerEvent.TIMER):
					_tick++;
					
					dispatchTimerEvent(GameTimerEvent.ON_TICK);
					break;
					
				case(TimerEvent.TIMER_COMPLETE):
					dispatchTimerEvent(GameTimerEvent.ON_TIME_LIMIT);
					break;
					
				default:
					break;
			}
		}
		
		//---------------------------------------------------------------------
		//  Event Dispatching
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function dispatchTimerEvent(type:String):void {
			this.dispatchEvent(new GameTimerEvent(type, false, false, _tick));
		}
		
		
		/**
		 * Start Timer.
		 */
		public function start():void {
			if (!_isOnStart) {
				_isOnStart = true;
				
				resetValues();
				startTimer();
			}
		}
		
		/**
		 * Stop Timer.
		 */
		public function stop():void {
			if (_isOnStart) {
				_isOnStart = false;
				
				stopTimer();
			}
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			destroyTimer();
			
			_delayTime = 0;
			_maxTime = 0;
			_isOnStart = false;
		}
		
		
		/**
		 * @private
		 */
		public function get isOnStart():Boolean {
			return _isOnStart;
		}
	}
}
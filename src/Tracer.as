package {
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * Tracer
	 * 
	 * @author David Massenot
	 */
	public class Tracer {
		public static const PROD_MODE:String = 'prod';
		public static const DEV_MODE:String = 'dev';
		public static const DEBUG_MODE:String = 'debug';
		public static const TEST_MODE:String = 'test';
		
		private static var __mode:String;
		
		
		/**
		 * Add Flash trace.
		 * 
		 * @param	target
		 * @param	id
		 * @param	...rest
		 */
		public static function addTrace(target:Object, id:String, ...rest):void {
			if (!target) return;
			if (!id) id = 'null';
			
			switch (__mode) {
				case(PROD_MODE):
					// No trace
					break;
					
				case(DEV_MODE):
					trace(rest);
					break;
					
				case(DEBUG_MODE):
					trace(getQualifiedClassName(target), ' :: ', rest);
					break;
					
				case(TEST_MODE):
					trace('[[ ' + id + ' ]]', rest);
					break;
					
				default:
					trace(rest);
					break;
			}
		}
		
		/**
		 * Add Flash log.
		 * 
		 * @param	target
		 * @param	member
		 */
		public static function addLog(target:Object, member:String):void {
			if (!target) return;
			if (!member) member = 'null';
			
			switch (__mode) {
				case(PROD_MODE):
					// No trace
					break;
					
				case(DEV_MODE):
					trace(member);
					break;
					
				case(DEBUG_MODE):
					trace(getQualifiedClassName(target), ' :: ', member);
					break;
					
				case(TEST_MODE):
					trace(member);
					break;
					
				default:
					trace(member);
					break;
			}
		}
		
		/**
		 * Set Tracer mode.
		 * 
		 * @param	mode
		 */
		public static function setMode(mode:String):void {
			__mode = mode;
		}
	}
}
package dung.dung.dung.errors
{
	/**
	 * Thrown when calls to <code>NodeMap.mapPath</code> are in conflict
	 * or ambiguous (not specific enough).
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  10.09.2010
	 */
	
	public class NodeMapConflictError extends Error
	{
		private var _cls:Class
		
		public function NodeMapConflictError(message:String, cls:Class)
		{
			_cls = cls;
			super(message);
		}

		public function toString():String
		{
			return "NodeMapConflictError: " + this.message + 
				" conflicts with the path registered for " + _cls;
		}
	}
}
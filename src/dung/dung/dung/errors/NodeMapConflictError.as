package dung.dung.dung.errors
{
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
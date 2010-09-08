package easymode.errors
{

	public class NodeMapInvalid extends Error
	{
	
		public function NodeMapInvalid(message:String)
		{
			super(message);
		}
		
		public function toString():String
		{
			return "NodeMapInvalid: " + message + " does not match any registered rule";
		}
	}

}

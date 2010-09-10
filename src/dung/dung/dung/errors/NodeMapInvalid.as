package dung.dung.dung.errors
{
	/**
	 * Thrown when a call to NodeMap.resolve fails
	 * to find an entry in the NodeMap.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  10.09.2010
	 */
	
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

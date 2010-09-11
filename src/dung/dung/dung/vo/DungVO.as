package dung.dung.dung.vo
{
	import org.swiftsuspenders.Injector;
	
	/**
	 * A lighweight value object used to sort
	 * The to-be-created objects by type.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  10.09.2010
	 */
	
	public class DungVO
	{
		public var viewClass:Class;
		public var voClass:Class;
		public var node:XML;
		public var injector:Injector;
		
		public function DungVO(viewClass:Class, voClass:Class, node:XML, injector:Injector)
		{
			super();
			this.viewClass = viewClass;
			this.voClass = voClass;
			this.node = node;
			this.injector = injector;
		}

		public function toString():String
		{
			return "[Dung viewClass=" + viewClass +" voClass="+ voClass + " + node="+ node + " injector=" + injector + "]";
		}

	}
}
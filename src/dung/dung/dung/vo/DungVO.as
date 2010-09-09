package dung.dung.dung.vo
{
	import org.robotlegs.core.IInjector;
	
	public class DungVO
	{
		public var viewClass:Class;
		public var voClass:Class;
		public var node:XML;
		public var injector:IInjector;
		
		public function DungVO(viewClass:Class, voClass:Class, node:XML, injector:IInjector)
		{
			super();
			this.viewClass = viewClass;
			this.voClass = voClass;
			this.node = node;
			this.injector = injector;
		}

	}
}
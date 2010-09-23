package mocks
{	
	public class VOMock2
	{
		public var url:XML;
		
		[Inject(name='title')]
		public var title:String;
		
		[Inject(name='url')]
		public function set urlSink(value:XML):void
		{
			url = value;
		}
		
		public function toString():String
		{
			return "[VOMock2 title='"+ title +"' url.a.@href='" + url.a.@href +"']";
		}
	}
}
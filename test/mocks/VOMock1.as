package mocks
{	
	public class VOMock1
	{
		[Inject(name='ammount')]
		public var ammount:String;
		
		[Inject(name='tax')]
		public var tax:String;
		
		public function toString():String
		{
			return "[VOMock1 ammount="+ammount+" tax="+tax+"]";
		}
	}
}
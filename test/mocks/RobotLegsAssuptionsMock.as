package mocks
{	
	import flash.display.DisplayObject;
	
	public class RobotLegsAssuptionsMock extends Object
	{
		[Inject(name='moo')]
		public var moo:String = 'moo';
		
		[Inject(name='lmao')]
		public var lmao:String = 'lmao';
	
		public function toString():String
		{
			return "[RobotLegsAssuptionsMock moo='" + moo +"' lmao='"+ lmao +"']";
		}
	}
}
package mocks
{	
	import flash.display.Sprite;
	import dung.dung.dung.interfaces.IChildList;
	
	public class ViewMock1 extends Sprite
	{
		[Inject]
		public var dataProvider:VOMock1;
		
		[Inject]
		public var childList:IChildList;
		
		public function ViewMock1()
		{
			super();
		}

	}
}
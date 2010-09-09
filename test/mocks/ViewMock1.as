package mocks
{	
	import flash.display.Sprite;
	
	public class ViewMock1 extends Sprite
	{
		
		[Inject]
		var childList:IChildList;
		
		public function ViewMock1()
		{
			super();
		}

	}
}
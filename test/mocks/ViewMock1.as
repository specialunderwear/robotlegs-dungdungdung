package mocks
{	
	import flash.display.Sprite;
	import dung.dung.dung.interfaces.IChildList;
	import dung.dung.dung.core.ChildList;
	
	public class ViewMock1 extends Sprite
	{
		[Inject]
		public var dataProvider:VOMock1;
		
		[Inject]
		public var childList:IChildList;
		
		[PostConstruct]
		public function initialize():void
		{
			if (dataProvider.ammount == '9') {
				(childList as ChildList).injector.mapClass(ViewMock2, ViewMock3);
			}
			childList.addChildrenOfTypeTo(ViewMock2, this);
		}
		public function ViewMock1()
		{
			super();
		}

	}
}
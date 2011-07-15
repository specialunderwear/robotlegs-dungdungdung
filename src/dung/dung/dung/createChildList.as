package dung.dung.dung
{	
	import org.swiftsuspenders.Injector;
	import dung.dung.dung.core.ChildList;
	import dung.dung.dung.interfaces.IChildList;
	
	public function createChildList(data:XMLList, injector:Injector):IChildList
	{
		var childList:IChildList = new ChildList(data);
		injector.injectInto(childList);
		return childList;
	}
}
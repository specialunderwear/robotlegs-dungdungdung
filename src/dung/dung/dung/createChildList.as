package dung.dung.dung
{	
	import org.swiftsuspenders.Injector;
	import dung.dung.dung.core.ChildList;
	import dung.dung.dung.interfaces.IChildList;
	
	/**
	 * Create a <code>ChildList</code> initialized from an <code>XMLList</code>.
	 * @param data List of nodes mapped in the <code>NodeMap</code>.
	 * @param injector An instance of <code>org.swiftsuspenders.Injector</code>.
	 * @return IChildList A factory object that creates objects from xml, as mapped in the <code>NodeMap</code>.
	 */
	
	public function createChildList(data:XMLList, injector:Injector):IChildList
	{
		var childList:IChildList = new ChildList(data);
		injector.injectInto(childList);
		return childList;
	}
}
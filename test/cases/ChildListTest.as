package cases
{	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import dung.dung.dung.core.NodeMap;
	import dung.dung.dung.interfaces.INodeMap;
	import data.childlistdata;
	import dung.dung.dung.core.ChildList;
	import dung.dung.dung.interfaces.IChildList;
	import org.flexunit.Assert;
	
	public class ChildListTest
	{
		private var injector:IInjector;
		private var nodeMap:NodeMap;
		
		[Before]
		public function runBeforeEachTest():void
		{
			injector = new SwiftSuspendersInjector;
			nodeMap = new NodeMap();
			injector.mapValue(IInjector, injector);
			injector.mapValue(INodeMap, nodeMap);
			injector.mapClass(IChildList, ChildList);
			injector.mapValue(String, 'children', ChildList.CHILDLIST_NODE_NAME);
		}
		
		[Test]
		public function canCreateChildNode():void
		{
			var childList:ChildList = new ChildList(childlistdata.item);
			injector.injectInto(childList);
			Assert.assertTrue('injector was set', childList.injector);
			Assert.assertTrue('nodemap was set', childList.nodeMap);
		}
		
	}
}
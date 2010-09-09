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
	import mocks.ViewMock1;
	
	public class ChildListTest
	{
		private var injector:IInjector;
		private var nodeMap:NodeMap;
		
		private function mapItems():ChildList
		{
			injector.mapClass(ViewMock1, ViewMock1);
			nodeMap.mapPath('item', ViewMock1);
			Assert.assertEquals('4 item nodes should be in the xml', 4, childlistdata.item.length());
			
			var childList:ChildList = new ChildList(childlistdata.item);
			injector.injectInto(childList);
			return childList;
		}
		
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
		
		[Test]
		public function canEvaluateChildList():void
		{
			var childList:ChildList = mapItems();
			var objects:Array = childList.children();
			Assert.assertEquals('4 children should be created', 4, objects.length);
		}
		
		[Test]
		public function childListAreInjectedWhenANodeHasChildren():void
		{
			nodeMap.mapPath('item.children.message', ViewMock1);
			var childList:ChildList = mapItems();
			var objects:Array = childList.children();
			for each (var item:ViewMock1 in objects) {
				Assert.assertEquals('each item has 3 child nodes', 3, item.childList.children().length);
			}
		}
		
	}
}
package cases
{	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.flexunit.Assert;
	import dung.dung.dung.core.NodeMap;

	import data.nodemapdata;
	
	public class NodeMapTest
	{
		public var nodeMap:NodeMap
		public var menu:XML;
		public var menuitems:XMLList;
		public var menuitems2:XMLList;
		
		[Before]
		public function mapPaths():void
		{
			nodeMap = new NodeMap();
			nodeMap.mapPath('menu', Sprite);
			nodeMap.mapPath('menu.children.menuitem', DisplayObject);
			nodeMap.mapPath('pages.page.menuitem', MovieClip)
			
			menu = XML(nodemapdata.assets.menu);
			menuitems = nodemapdata.assets.menu.children.menuitem;
			menuitems2 = nodemapdata.pages.page.menuitem;
		}
		
		[Test]
		public function testResolveSingle():void
		{
			Assert.assertEquals(
				'nodemap should return Sprite when handed a menu node.',
				Sprite, nodeMap.resolve(menu).viewClass
			);
		}
		
		[Test]
		public function testResolveMenuItems():void
		{
			for each (var node:XML in menuitems) {
				Assert.assertEquals(
					'nodeMap should return DisplayObject when handed a menuitem node that is a child of menu', 
					DisplayObject, nodeMap.resolve(node).viewClass
				);
			}
		}

		[Test]
		public function testDifferentPathsForSameItem():void
		{
			for each (var node:XML in menuitems2) {
				Assert.assertEquals(
					'the menuitem node is mapped 2 times but should yield different objects for both maps', 
					MovieClip, nodeMap.resolve(node).viewClass
				);
			}
		}
		
		[Test(expects='dung.dung.dung.errors.NodeMapConflictError')]
		public function notSpecificEnoughMapError():void
		{
			nodeMap.mapPath('menuitem', Class);
		}

		[Test(expects='dung.dung.dung.errors.NodeMapConflictError')]
		public function mapConflictError():void
		{
			nodeMap.mapPath('error.pages.page.menuitem', Class);
		}
	}
}
package cases
{	
	import easymode.datastructures.NodeMap;
	import data.xmldata;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.flexunit.Assert;
	
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
			nodeMap.addRule('menu', Sprite);
			nodeMap.addRule('menu.children.menuitem', DisplayObject);
			nodeMap.addRule('pages.page.menuitem', MovieClip)
			
			menu = XML(xmldata.assets.menu);
			menuitems = xmldata.assets.menu.children.menuitem;
			menuitems2 = xmldata.pages.page.menuitem;
		}
		
		[Test]
		public function testResolveSingle():void
		{
			Assert.assertEquals(
				'nodemap should return Sprite when handed a menu node.',
				nodeMap.resolve(menu).viewClass, Sprite
			);
		}
		
		[Test]
		public function testResolveMenuItems():void
		{
			for each (var node:XML in menuitems) {
				Assert.assertEquals(
					'nodeMap should return DisplayObject when handed a menuitem node that is a child of menu', 
					nodeMap.resolve(node).viewClass, DisplayObject
				);
			}
		}

		[Test]
		public function testDifferentPathsForSameItem():void
		{
			for each (var node:XML in menuitems2) {
				Assert.assertEquals(
					'the menuitem node is mapped 2 times but should yield different objects for both maps', 
					nodeMap.resolve(node).viewClass, MovieClip
				);
			}
		}
		
		[Test(expects='easymode.errors.NodeMapConflictError')]
		public function notSpecificEnoughMapError():void
		{
			nodeMap.addRule('menuitem', Class);
		}

		[Test(expects='easymode.errors.NodeMapConflictError')]
		public function mapConflictError():void
		{
			nodeMap.addRule('error.pages.page.menuitem', Class);
		}
	}
}
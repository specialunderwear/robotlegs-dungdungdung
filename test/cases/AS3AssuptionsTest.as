package cases
{	
	
	import flash.utils.Dictionary;
	import org.flexunit.Assert;
	import flash.display.DisplayObject;
	
	public class AS3AssuptionsTest
	{
		[Test]
		public function undefinedDictKey():void
		{
			var dict:Dictionary = new Dictionary();
			Assert.assertTrue('Undefined dict keys are null', dict[Class] === undefined);
		}
		
		[Test]
		public function dictKeysCanBeLooped():void
		{
			var dict:Dictionary = new Dictionary();
			dict[Class] = true;
			dict[Boolean] = true;
			
			Assert.assertTrue('Class is a key in dicy', Class in dict);
			Assert.assertTrue('Boolean is a key in dicy', Boolean in dict);
			
			var count:uint = 0;
			for each (var item:* in dict) {
				count++;
			}
			
			Assert.assertEquals('dict should have 2 items', 2, count);
		}
		
		[Test]
		public function dictKeysAreNotNescessarilyStrings():void
		{
			var dict:Dictionary = new Dictionary();
			dict[Class] = true;
			dict[Boolean] = true;
			for (var key:* in dict) {
				Assert.assertFalse('These keys are not strings', key is String);
			}
		}
		
		[Test]
		public function allClassesAreInstancesOfClass():void
		{
			Assert.assertTrue('DisplayObject is a Class', DisplayObject is Class);
			Assert.assertTrue('int is a Class', int is Class);
			Assert.assertFalse('null is not a Class', null is Class);
		}

		[Test]
		public function nodeNameStringComparisonWorks():void
		{
			var node:XML = <root><item>hi</item></root>;
			for each (var item:XML in node.item) {
				Assert.assertEquals('nodename should equal item', 'item', item.name());
			}
		}

		[Test]
		public function childrenAsANodeNameDoesNotClashWithTheChildrenMethod():void
		{
			var xml:XML = <root/>;
			Assert.assertFalse('There should be no children', xml.hasOwnProperty('children'));
			
			xml = <root><children>hi</children></root>;
			Assert.assertTrue('There should be children', xml.hasOwnProperty('children'));
		}
	}
}
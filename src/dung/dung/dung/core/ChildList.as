package dung.dung.dung.core
{	
	import dung.dung.dung.interfaces.IChildList;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import dung.dung.dung.datastructures.Node;
	import dung.dung.dung.vo.DungVO;
	import dung.dung.dung.interfaces.INodeMap;
	import flash.display.DisplayObject;
	import dung.dung.dung.core.ChildList;
	import org.robotlegs.core.IInjector;
	
	public class ChildList
		implements IChildList
	{
		public static const CHILDLIST_NODE_NAME:String = 'dung.dung.dung.core.ChildList.childListNodeName';
		
		protected var _dataProvider:XMLList;
		protected var _typeDict:Dictionary;
		
		[Inject(name='dung.dung.dung.core.ChildList.childListNodeName')]
		public var childListNodeName:String = 'children';
		
		[Inject]
		public var nodeMap:INodeMap;
		
		[Inject]
		public var injector:IInjector;
		
		public function ChildList(dataProvider:XMLList)
		{
			super();
			_dataProvider = dataProvider;
		}
		
		protected function prepareObjects():void
		{
			var currentNode:Node;
			
			for each (var node:XML in _dataProvider) {
				currentNode = nodeMap.resolve(node);
				
				// create type dict array
				if (_typeDict[currentNode.viewClass] === undefined)
					_typeDict[currentNode.viewClass] = [];
				
				// push new dung
				_typeDict[currentNode.viewClass].push(new DungVO(
					currentNode.viewClass,
					currentNode.voClass,
					node,
					injector)
				);
			}
		}
		
		public function addChildrenTo(parent:DisplayObjectContainer):Array
		{
			var allChildren:Array = [];
			for (var key:* in _typeDict) {
				allChildren.concat( this.addChildrenOfTypeTo(key, parent) );
			}
			return allChildren;
		}
		
		public function addChildrenOfTypeTo(type:Class, parent:DisplayObjectContainer):Array
		{
			var childrenOfType:Array = this.childrenOfType(type);
			for each (var child:DisplayObject in childrenOfType) {
				parent.addChild(child);
			}
			return childrenOfType;
		}
		
		public function children():Array
		{
			var allChildren:Array = [];
			for (var key:* in _typeDict) {
				allChildren.concat( this.childrenOfType(key) );
			}
			return allChildren;
		}
		
		public function childrenOfType(type:Class):Array
		{
			var childrenOfType:Array = [];
			
			// loop though dungs of certain type.
			for each (var dung:DungVO in _typeDict[type]) {

				// create value object defined in dung
				if (dung.voClass is Class) {
					for each (var childNode:XML in dung.node.children()) {

						// if the node is named whatever childListNodeName is set to,
						// don't map that for the vo, it goes in the view.
						if (childNode.name() == childListNodeName) {
							continue;
						}
						
						// If the node is complex, bind as xml.
						if (childNode.hasComplexContent()) {
							injector.mapValue(XML, childNode, childNode.name());
						} else { // if simple bind as String
							injector.mapValue(String, childNode.text(), childNode.name())
						}
					}
					
					// if there are children, map an IChildList with that node
					// as the dataProvider.
					if (dung.node.hasOwnProperty(childListNodeName)) {
						var children:XMLList = dung.node[childListNodeName].children();
						/*injector.mapValue(XMLList, children, DATA_PROVIDER_INJECTION_MAP_NAME);*/
						var childList:ChildList = new ChildList(children);
						injector.injectInto(childList);
						injector.mapValue(IChildList, childList);
						
					}
					
					
					// create value object with all values mapped above injected!
					var vo:* = injector.getInstance(dung.voClass);
					
					// vo will be injected into view so map as value.
					injector.mapValue(dung.voClass, vo);
				}
				
				// create view object with all dependencies injected.
				var viewInstance:DisplayObject = injector.getInstance(dung.viewClass)
				childrenOfType.push(viewInstance);
			}
			
			return childrenOfType;
		}
	  

	}
}
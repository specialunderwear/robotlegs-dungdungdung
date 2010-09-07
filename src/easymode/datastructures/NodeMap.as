package easymode.datastructures
{	
	import easymode.datastructures.Node;
	import flash.utils.Proxy;
	import easymode.errors.NodeMapDuplicateError;
	import easymode.interfaces.INodeWalker;
	import easymode.errors.NodeMapInvalid;
		
	public class NodeMap
		implements INodeWalker
	{
		private var _viewComponentClass:Class;
		private var _valueObjectClass:Class;
		private var _nodes:Object;
		
		public function NodeMap()
		{
			super();
			_nodes = {};
		}
		
		/*override flash_proxy function getProperty(name:*):*
		{
			return _nodes[name];
		}*/

		public function getOrCreateNode(name:String):Node
		{
			var node:Node;
			if (name in _nodes) {
				node = _nodes[name];
			} else {
				node = new Node();
				node.leaf = false;
				_nodes[name] = node;
			}
			
			return node;
		}
		
		public function addRule(rule:String, viewComponentClass:Class, valueObjectClass:Class=null):void
		{
			var paths:Array = rule.split('.').reverse();
			var current:Node = getOrCreateNode(paths.shift());
			var leafFound:Boolean = false;

			for each (var path:String in paths) {
				current = current.getOrCreateNode(path);
				leafFound = current.leaf || leafFound;
			}

			if (leafFound || current.numNodes) {
				throw new NodeMapDuplicateError(rule, viewComponentClass);
			}
			
			current.viewClass = viewComponentClass;
			current.voClass = valueObjectClass;
			current.leaf = true;
		}
		
		public function resolve(obj:XML):Node
		{
			if (obj.name() in _nodes) {
				return _nodes[obj.name()].resolveWithParent(obj);
			}
			throw new NodeMapInvalid(String(obj.name()));
		}

	}
}
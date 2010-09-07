package easymode.datastructures
{	
	import easymode.errors.NodeMapInvalid;
	import easymode.interfaces.INodeWalker;
	
	public class Node
		implements INodeWalker
	{
		public var leaf:Boolean = true;
		public var viewClass:Class;
		public var voClass:Class;
		protected var _nodes:Array;
		
		public function Node()
		{
			super();
			_nodes = [];
		}

		public function getOrCreateNode(name:String):Node
		{
			var node:Node
			if (name in _nodes) {
				node = _nodes[name];
			} else {
				node = new Node();
				node.leaf = false;
				_nodes[name] = node;
			}
			
			return node;
		}

		public function resolveWithParent(obj:XML):Node
		{
			if (leaf) {
				return this;
			} else {
				var parent:XML = obj.parent();
				if (parent.name() in _nodes) {
					return _nodes[parent.name()].resolveWithParent(parent)
				}
			}
			
			throw new NodeMapInvalid(obj.name() + '.' + parent.name());
			
		}
	}
}
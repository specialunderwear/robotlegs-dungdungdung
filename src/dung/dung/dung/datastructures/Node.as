package dung.dung.dung.datastructures
{
	import mx.utils.ObjectUtil;
	import dung.dung.dung.errors.NodeMapInvalid;
	import dung.dung.dung.interfaces.INodeWalker;
	
	/**
	 * The Node is used by NodeMap to store paths as
	 * a tree.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  08.09.2010
	 * @see easymode.datastructures.NodeMap;
	 */
	
	public final class Node
		implements INodeWalker
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		public var leaf:Boolean = false;
		public var viewClass:Class;
		public var voClass:Class;
		
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		
		private var _nodes:Object;
		private var _numNodes:uint;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * The number of paths that pass through this node.
		 */
		
		public function get numNodes():uint
		{
			return _numNodes;
		}

		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		
		public function Node()
		{
			super();
			_nodes = {};
			_numNodes = 0;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Retrieves a subnode by a certain name.
		 * @param name The name of the node.
		 * @return Node or null
		 */
		
		public function getNodeByName(name:String):Node
		{
			if (name in _nodes) {
				return _nodes[name];
			}
			return null;
		}
		
		/**
		 * Retrieves a subnode by a certain name, but if it doesn't exist yet.
		 * the node will be created.
		 * @param name The name of the node.
		 * @return Node 
		 */
		
		public function getOrCreateNodeByName(name:String):Node
		{
			var node:Node = getNodeByName(name);
			 if (! node) {
				node = new Node();
				_nodes[name] = node;
				_numNodes++;
			}
			
			return node;
		}

		/**
		 * Returns the node identified by a piece of xml.
		 * @param obj the xml that identifies the node.
		 * @return Node 
		 */
		
		public function resolveByXMLSignature(obj:XML):Node
		{
			if (leaf) {
				return this;
			} else {
				var parent:XML = obj.parent();
				if (parent.name() in _nodes) {
					return _nodes[parent.name()].resolveByXMLSignature(parent)
				} else {
					trace(ObjectUtil.toString(_nodes));
				}
			}
			
			throw new NodeMapInvalid(parent.name() + '.' + obj.name() );
			
		}
		
		public function toString():String
		{
			return "[Node leaf=" + leaf +" viewClass=" + viewClass +" voClass="+ voClass + " + numNodes="+ numNodes + "]";
		}
	}
}
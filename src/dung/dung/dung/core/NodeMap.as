package dung.dung.dung.core
{
	import dung.dung.dung.datastructures.Node;
	import dung.dung.dung.errors.NodeMapConflictError;
	import dung.dung.dung.errors.NodeMapInvalid;
	import dung.dung.dung.interfaces.INodeMap;
	
	/**
	 * The NodeMap is used to map xpath like xml
	 * selectors to viewComponents + value objects.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  08.09.2010
	 */
	
	public class NodeMap
		implements INodeMap
	{
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		
		private var _viewComponentClass:Class;
		private var _valueObjectClass:Class;
		private var _rootNode:Node;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		
		public function NodeMap()
		{
			super();
			_rootNode = new Node();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Adds a rule that associates a node in the xml with a view component and a value object.
		 * 
		 * @param rule a xpath like pattern: 'node.subnode.etc' enough to uniquely identify 
		 * a node in an xml tree.
		 * @param viewComponentClass The class of the viewcomponent that should be created when a node
		 * matched by <code>rule</code> is encountered in the xml.
		 * @param valueObjectClass The class of the valueobject that should be created when a node
		 * matched by <code>rule</code> is encountered in the xml; the direct children of this node
		 * will be bound to the valueobject using <code>mapValue(String, childnode, childnode.name())</code>.
		 * @throws NodeMapConflictError when 2 rules would conflict or shadow eachother.
		 */
		
		public function mapPath(rule:String, viewComponentClass:Class, valueObjectClass:Class=null):void
		{
			var paths:Array = rule.split('.').reverse();
			var current:Node = _rootNode;
			var leafFound:Boolean = false;

			for each (var path:String in paths) {
				current = current.getOrCreateNodeByName(path);
				leafFound = current.leaf || leafFound;
			}

			if (leafFound || current.numNodes) {
				throw new NodeMapConflictError(rule, viewComponentClass);
			}
			
			current.viewClass = viewComponentClass;
			current.voClass = valueObjectClass;
			current.leaf = true;
		}
		
		/**
		 * Given an xml node, <code>resolve</code> will return the node object that
		 * can be matched to that node. The node object contains a view Class and a
		 * value object class.
		 * @param obj the xml node
		 * @return Node 
		 * @throws NodeMapInvalid when no rule can match the piece of xml.
		 */
		
		public function resolve(obj:XML):Node
		{
			var node:Node = _rootNode.getNodeByName(obj.name());
			if (! node) {
				throw new NodeMapInvalid(obj.name())
			}
			
			if (node.leaf)
				return node;
				
			return node.resolveByXMLSignature(obj);
		}

	}
}
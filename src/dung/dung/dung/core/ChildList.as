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
	import org.swiftsuspenders.Injector;
	import dung.dung.dung.outerspace;
	import dung.dung.dung.datastructures.ChildListIterator;
	import dung.dung.dung.interfaces.IChildListIterator;
	
	/**
	 * A lazy list of viewcomponents that are created when accessed.
	 * 
	 * If specified so in the <code>nodeMap</code>, a value object will be created and
	 * all properties marked for injection in the vo Class will be bound from the
	 * xml.
	 * 
	 * When manually constructing a <code>ChildList</code>, you must pass an <code>XMLList</code>
	 * to the constructor, and after that inject dependencies:
	 * <pre>
	 * var c:IChildList = new ChildList(<root><a/><b/></root>.children());
	 * injector.injectInto(c);
	 * </pre>
	 * 
	 * Only then, the object is ready for use.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @see dung.dung.dung.core.NodeMap;
	 * @author Lars van de Kerkhof
	 * @since  10.09.2010
	 */
	
	public class ChildList
		implements IChildList
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		/**
		 * The name of the node in your xml that designates child objects.
		 * you must map this name somewhere like this:
		 * <pre>injector.mapValue(String, 'children', ChildList.CHILDLIST_NODE_NAME);</pre>
		 * 
		 * In this case any xml node named 'children' will trigger the creation of another ChildList.
		 */
		public static const CHILDLIST_NODE_NAME:String = 'dung.dung.dung.core.ChildList.childListNodeName';

		/** @private */
		[Inject(name='dung.dung.dung.core.ChildList.childListNodeName')]
		public var childListNodeName:String = 'children';

		/** The instance of INodeMap used by ChildList, it is marked for injection. */
		[Inject]
		public var nodeMap:INodeMap;

		/** The instance of the injector, used to create all objects managed by ChildList */
		[Inject]
		public var injector:Injector;
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		/** @private marks that the dataProvider has been prepared and parsed into DungVO objects. */
		private var _prepared:Boolean = false;
		
		/** @private The dataProvider that is used to determine which objects to create. */
		protected var _dataProvider:XMLList;
		/** @private holds the DungVO's sorted by type. */
		protected var _typeDict:Dictionary;
		/** @private holds the DungVO's in the original order */
		protected var _allDungs:Array;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * Creates a ChildList and sets the dataProvider.
		 * @param dataProvider while marked as optional, you must always pass the dataprovider!
		 * @constructor
		 */
		
		public function ChildList(dataProvider:XMLList=null)
		{
			super();
			_typeDict = new Dictionary();
			_allDungs = [];
			_dataProvider = dataProvider;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Returns an array of objects defined by the dataProvider after adding
		 * them as children to <code>parent</code>.
		 * @param parent The DisplayObjectContainer you want the children to be added to.
		 * @return array of objects as defined by <code>dataProvider</code>.
		 */
		
		public function addChildrenTo(parent:DisplayObjectContainer):Array
		{
			prepareObjects();
			
			var allChildren:Array = children();
			for each (var child:DisplayObject in allChildren) {
				parent.addChild(child);
			}
			return allChildren;
		}
		
		/**
		 * Returns an array of objects of type <code>type</code> after adding them
		 * to <code>parent</code> as children.
		 * @param type The type of the objects you want to select.
		 * @param parent The <code>DisplayObjectContainer</code> you want the children you selected to be added to.
		 * @return array of objects of a specific type.
		 */
		
		public function addChildrenOfTypeTo(type:Class, parent:DisplayObjectContainer):Array
		{
			prepareObjects();
			
			var childrenOfType:Array = this.childrenOfType(type);
			for each (var child:DisplayObject in childrenOfType) {
				parent.addChild(child);
			}
			return childrenOfType;
		}
		
		/**
		 * Return an array of objects, as defined by the <code>dataProvider</code> and
		 * returns them in an array.
		 * @return array of objects as defined by <code>dataProvider</code>.
		 */
		
		public function children():Array
		{
			prepareObjects();
			
			var allChildren:Array = [];
			for each(var dung:DungVO in _allDungs) {
				allChildren.push( outerspace::objectDefinedBy(dung) )
			}
			return allChildren;
		}

		/**
		 * Creates an array of objects of type <code>type</code> and returns them
		 * in an array.
		 * @param type The type of the objects you want to select.
		 * @return array of objects of a specific type. 
		 */
		
		public function childrenOfType(type:Class):Array
		{
			prepareObjects();
			
			var childrenOfType:Array = [];
			
			// loop though dungs of certain type.
			for each (var dung:DungVO in _typeDict[type]) {
				childrenOfType.push(outerspace::objectDefinedBy(dung));
			}

			return childrenOfType;
		}
		
		public function iteratorForType(type:Class):IChildListIterator
		{
			prepareObjects();
			
			return new ChildListIterator(this, this._typeDict[type]);
		}
		
		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * When the IChildList methods are accessed, the dataProvider must be parsed
		 * into DungVO objects, this will sort the objects to be created by type.
		 * @private
		 */
		
		protected function prepareObjects():void
		{
			if (! _prepared) {
				var currentNode:Node;

				for each (var node:XML in _dataProvider) {
					currentNode = nodeMap.resolve(node);

					// create type dict array
					if (_typeDict[currentNode.viewClass] === undefined)
						_typeDict[currentNode.viewClass] = [];
					
					var dung:DungVO = new DungVO(
						currentNode.viewClass,
						currentNode.voClass,
						node,
						injector
					);
					
					// push new dung
					_allDungs.push(dung);
					_typeDict[currentNode.viewClass].push(dung);
				}
				// we don't need the dataProvider anymore.
				_dataProvider = null;
				_prepared = true;
			}
		}
		
		/**
		 * Maps the passed node in the injector and automatically selects the correct type.
		 * 
		 * Simple nodes will be mapped as string, but XML nodes will be mapped as XML.
		 * @param childNode A single xml node that should be bound to a VO or view component.
		 * @private
		 */
		
		protected function mapAsStringOrXML(childNode:XML):void {
			// If the node is complex, bind as xml.
			if (childNode.hasComplexContent()) {
				injector.mapValue(XML, childNode, childNode.name());
			} else { // if simple bind as String
				injector.mapValue(String, childNode.text(), childNode.name())
			}
		}
		
		/**
		 * Creates a new child list from an <code>XMLList</code> and maps it for injection.
		 * 
		 * The <code>ChildList</code> will have it's own injector, so it doesn't matter at all if
		 * you override mappings when inside a viewcomponent being constucted by the childlist.
		 * @param children The <code>XMLList</code> that contains all the data needed to construct the objects as defined in the <code>NodeMap</code>.
		 * @private
		 */
		
		protected function mapChildListFrom(children:XMLList):void
		{
			var childList:ChildList = new ChildList(children);

			// create child injector so we can override mappings without
			// messing up global mappings.
			var childInjector:Injector = injector.createChildInjector();
			// remap Injector to use the child injector here.
			childInjector.mapValue(Injector, childInjector);
			// inject injector and nodeMap, using the childInjector, which overrides the Injector mapping.
			childInjector.injectInto(childList);
		
			// map as IChildList to be injected into the view, with the normal injector.
			injector.mapValue(IChildList, childList);
		}
		
		/**
		 * Returns the object/viewCompenent defined by the data in the <code>dung</code> parameter.
		 * Such an object is mapped in the <code>NodeMap</code>.
		 * 
		 * If the object does not yet exist, it will be created.
		 * @param dung The value object that holds all data relevant for constructing an object mapped in <code>NodeMap</code>.
		 * @private
		 */
		
		outerspace function objectDefinedBy(dung:DungVO):Object
		{
			// If we allready created the object, return existing instance.
			if (! dung.viewInstance) {
				// map properties
				for each (var childNode:XML in dung.node.children()) {

					// if the node is named whatever childListNodeName is set to,
					// don't map that for the vo, it goes in the view.
					if (childNode.name() == childListNodeName) {
						continue;
					}
					
					mapAsStringOrXML(childNode);
				}
				
				// create value object defined in dung
				if (dung.voClass is Class) {
				
					// create value object with all values mapped above injected
					// and map it because it will be injected into view.
					// must use instantiate for the VO creation, because we are
					// mapping the same Class with mapValue!!
					injector.mapValue(dung.voClass, injector.instantiate(dung.voClass));
				}
			
				// if there are children, map an IChildList with that node
				// as the dataProvider.
				if (dung.node.hasOwnProperty(childListNodeName)) {
				
					var children:XMLList = dung.node[childListNodeName].children();
					mapChildListFrom(children);
				}
			
				// create view object with all dependencies injected.
				dung.viewInstance = injector.getInstance(dung.viewClass);
			}
			return dung.viewInstance;
		}
		
		outerspace function deleteItemFromAll(dung:DungVO):Boolean
		{
			return delete _allDungs[_allDungs.indexOf(dung)];
		}
	}
}
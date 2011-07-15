package dung.dung.dung.datastructures
{	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import dung.dung.dung.outerspace;
	import dung.dung.dung.core.ChildList;
	import dung.dung.dung.interfaces.IChildListIterator;
	
	/**
	 * This iterator supports lazy creation of items in dungdungdung.
	 * 
	 * Instead of creating an entire array of items, the iterator will create an
	 * item each tick of the for loop. This means that if you stop the loop before you
	 * reach the end, you will not have created all items, this way not wasting memory.
	 * 
	 * You can also get an item by index:
	 * 
	 * <code>childList.iteratorForType(SomeType)[1]</code>
	 * 
	 * Will only create the object at index 1.
	 * 
	 * Also the iterator is the only way you can delete separate items from the child list,
	 * by using the delete operator. You can also null them to set them up for garbage collection.
	 * 
	 * <pre>
	 * <code>
	 * var iter:IChildListIterator = childList.iteratorForType(ViewMock1);
	 * iter[0] = null;
	 * delete iter[2];
	 * </code>
	 * 
	 * </pre>
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lars van de Kerkhof
	 * @since  27.06.2011
	 */
	
	public class ChildListIterator extends Proxy
		implements IChildListIterator
	{
		protected var _typeArray:Array;
		protected var _childList:ChildList;
		
		/**
		 * Convert an unknown object into an integer.
		 * @param name Some object
		 * @private
		 * @return int 
		 */
		
		protected function toIndex(name:*):int
		{
			return int(Number(name))
		}
		
		public function ChildListIterator(childList:ChildList, typeArray:Array)
		{
			_childList = childList;
			_typeArray = typeArray;
		}
		
		flash_proxy override function hasProperty(name:*):Boolean
		{
			return toIndex(name) < _typeArray.length;
		}
		
		flash_proxy override function nextName(index:int):String
		{
			return flash_proxy::nextNameIndex(index).toString();
		}
		
		flash_proxy override function nextNameIndex(index:int):int
		{
			if (index < _typeArray.length)
				return index + 1;
			
			return 0;
		}
		
		/**
		 * get or create the object uniquely described by the dungvo at the speciafied index.
		 * @inheritDoc
		 */
		
		flash_proxy override function nextValue(index:int):*
		{
			return _childList.outerspace::objectDefinedBy(_typeArray[index - 1]);
		}

		flash_proxy override function getProperty(name:*):*
		{
			return _childList.outerspace::objectDefinedBy(_typeArray[name]);
		}
		
		/**
		 * Set the viewInstance, but leave the rest of the DungVO alone.
		 * @inheritDoc
		 */
		
		flash_proxy override function setProperty(name:*, value:*):void
		{
			_typeArray[name].viewInstance = value;
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean
		{
			;
			return _childList.outerspace::deleteItemFromAll(_typeArray[name]) &&
				delete _typeArray[name];
		}

	}
}
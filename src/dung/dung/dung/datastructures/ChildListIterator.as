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
		
		protected function toIndex(name:*):int
		{
			return int(Number(name))
		}
		
		public function ChildListIterator(childList:ChildList, typeArray:Array)
		{
			_childList = childList;
			_typeArray = typeArray;
		}
		
		flash_proxy override function getProperty(name:*):*
		{
			return _childList.outerspace::objectDefinedBy(_typeArray[name]);
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
		
		flash_proxy override function nextValue(index:int):*
		{
			trace("ChildListIterator::nextNameIndex()",  index, _typeArray[index]);
			return _childList.outerspace::objectDefinedBy(_typeArray[index - 1]);
		}
		
		flash_proxy override function setProperty(name:*, value:*):void
		{
			_typeArray[name].viewInstance = value;
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean
		{
			if (toIndex(name) < _typeArray.length) {
				_typeArray[name].viewInstance = null;
				return true;
			}
			
			return false;
		}

	}
}
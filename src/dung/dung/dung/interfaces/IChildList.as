package dung.dung.dung.interfaces
{	
	import flash.display.DisplayObjectContainer;
	import dung.dung.dung.interfaces.IChildListIterator;

	public interface IChildList {

		function addChildrenTo(parent:DisplayObjectContainer):Array;
		function addChildrenOfTypeTo(type:Class, parent:DisplayObjectContainer):Array;
		function children():Array;
		function childrenOfType(type:Class):Array;
		function iteratorForType(type:Class):IChildListIterator;
	}

}
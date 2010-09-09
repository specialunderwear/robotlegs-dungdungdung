package dung.dung.dung.interfaces
{	
	import flash.display.DisplayObjectContainer;

	public interface IChildList {

		function addChildrenTo(parent:DisplayObjectContainer):Array;
		function addChildrenOfTypeTo(type:Class, parent:DisplayObjectContainer):Array;
		function children():Array;
		function childrenOfType(type:Class):Array;
	}

}
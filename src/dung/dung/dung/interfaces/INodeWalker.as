package dung.dung.dung.interfaces
{
	import dung.dung.dung.datastructures.Node;
	
	public interface INodeWalker
	{
		function getNodeByName(name:String):Node;
		function getOrCreateNodeByName(name:String):Node;
	}
}
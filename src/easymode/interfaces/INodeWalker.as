package easymode.interfaces
{	
	import easymode.datastructures.Node;
	
	public interface INodeWalker
	{
		function getNodeByName(name:String):Node;
		function getOrCreateNodeByName(name:String):Node;
	}
}
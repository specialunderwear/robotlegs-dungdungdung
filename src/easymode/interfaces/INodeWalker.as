package easymode.interfaces
{	
	import easymode.datastructures.Node;
	
	public interface INodeWalker
	{
		function getOrCreateNode(name:String):Node;
	}
}
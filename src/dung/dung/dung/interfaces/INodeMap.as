package dung.dung.dung.interfaces
{	
	import dung.dung.dung.datastructures.Node;
	
	public interface INodeMap
	{
		function mapPath(rule:String, viewComponentClass:Class, valueObjectClass:Class=null):void;
		function resolve(obj:XML):Node;
	}
}
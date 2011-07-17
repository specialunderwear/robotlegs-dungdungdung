package dung.dung.dung
{
	import org.swiftsuspenders.Injector;
    import dung.dung.dung.core.NodeMap;
    import dung.dung.dung.interfaces.INodeMap;
    import dung.dung.dung.core.ChildList;

	/**
	 * Setup the dungdungdung nodemap and required injector mappings
	 * @param swiftSuspendersInjector A reference to the Injector, *NOT* IInjector
	 * @param childNodeName If you want to use a different element as <children/>
	 * 	to mark a childList, you can say which one using this parameter.
	 * @return the <code>INodeMap</code> instance that was mapped and created during setup.
	 */
	
	public function defaultSetup(swiftSuspendersInjector:Injector, childNodeName:String='children'):INodeMap
	{
	    // map the injector, dungdungdung needs Injector, not robotlegs IInjector,
	    // because it uses Injector.createChildInjector which is not declared in
	    // IInjector, so we must map it separately.
	    swiftSuspendersInjector.mapValue(Injector, swiftSuspendersInjector);

	    // create and map a NodeMap instance, you can also map it as a Singleton if
	    // you want.
	    var nodeMap:NodeMap = new NodeMap();
	    swiftSuspendersInjector.mapValue(INodeMap, nodeMap);

	    // now we must tell dungdungdung which xml nodes mark a *list*
	    // for the above xml *pages* marks a list, but that is the root list, all
	    // child lists are named *children*
	    swiftSuspendersInjector.mapValue(String, 'children', ChildList.CHILDLIST_NODE_NAME);
		
		return nodeMap;
	}
}
package
{	
	import cases.NodeMapTest;
	import cases.ChildListTest;
	import cases.AS3AssuptionsTest;
	import cases.RobotLegsAssuptionsTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Suite
	{
		public var nodeMapTest:NodeMapTest;
		public var childListTest:ChildListTest;
		public var as3AssuptionsTest:AS3AssuptionsTest;
		public var robotLegsAssuptionsTest:RobotLegsAssuptionsTest;
	}
}
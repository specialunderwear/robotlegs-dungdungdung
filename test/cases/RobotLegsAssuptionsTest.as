package cases
{	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import mocks.RobotLegsAssuptionsMock;
	import org.flexunit.Assert;
	import org.swiftsuspenders.InjectionConfig;
	import org.swiftsuspenders.Injector;
	import flash.system.System;
	
	public class RobotLegsAssuptionsTest
	{
		private var injector:Injector;
		
		[Before]
		public function init():void
		{
			injector = new SwiftSuspendersInjector;
		}
		
		[After]
		public function destroy():void
		{
			injector = null;
			System.gc();
		}
		
		[Test]
		public function mappingsDefinedInParentInjectorAfterChildInjectorWasCreatedWork():void
		{
			var rule:InjectionConfig = injector.mapClass(RobotLegsAssuptionsMock, RobotLegsAssuptionsMock);
			var childInjector:Injector = injector.createChildInjector();
			rule.setInjector(childInjector);
			childInjector.mapValue(String, 'haha', 'moo');
			
			// define new mapping in parent injector.
			injector.mapValue(String, 'whut', 'lmao')
			var mock:RobotLegsAssuptionsMock = childInjector.instantiate(RobotLegsAssuptionsMock);
			
			Assert.assertEquals('It should say hah', 'haha', mock.moo);
			Assert.assertEquals('It should say whut', 'whut', mock.lmao);
		}

	}
}
package cases
{	
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
			injector = new Injector;
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
			var childInjector:Injector = injector.createChildInjector();
			var rule:InjectionConfig = injector.mapClass(RobotLegsAssuptionsMock, RobotLegsAssuptionsMock);
			rule.setInjector(childInjector);
			childInjector.mapValue(String, 'haha', 'moo');
			
			// define new mapping in parent injector.
			injector.mapValue(String, 'whut', 'lmao')
			var mock:RobotLegsAssuptionsMock = childInjector.instantiate(RobotLegsAssuptionsMock);
			
			Assert.assertEquals('It should say hah', 'haha', mock.moo);
			Assert.assertEquals('It should say whut', 'whut', mock.lmao);
		}
		
		[Test]
		public function getInstanceReturnsANewInstanceIfNotSingleTon():void
		{
			injector.mapValue(String, 'whut', 'lmao')
			injector.mapValue(String, 'haha', 'moo');
			injector.mapClass(RobotLegsAssuptionsMock, RobotLegsAssuptionsMock);
			
			var mock:RobotLegsAssuptionsMock = injector.getInstance(RobotLegsAssuptionsMock);
			var differentMock:RobotLegsAssuptionsMock = injector.getInstance(RobotLegsAssuptionsMock);
			
			Assert.assertFalse('The objects should not be equal under strict equality', mock === differentMock);
			
			injector.mapSingleton(RobotLegsAssuptionsMock);
			mock = injector.getInstance(RobotLegsAssuptionsMock);
			differentMock = injector.getInstance(RobotLegsAssuptionsMock);

			Assert.assertTrue('The objects should now be equal under strict equality', mock === differentMock);
		}

	}
}
package cases
{	
	import mocks.RobotLegsAssuptionsMock;
	import org.flexunit.Assert;
	import org.swiftsuspenders.InjectionMapping;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.utils.SsInternal;
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
			var rule:InjectionMapping = injector.map(RobotLegsAssuptionsMock);
			rule.setInjector(childInjector);
			childInjector.map(String, 'moo').toValue('haha');
			
			// define new mapping in parent injector.
			injector.map(String, 'lmao').toValue('whut');
			var mock:RobotLegsAssuptionsMock = childInjector.SsInternal::instantiateUnmapped(RobotLegsAssuptionsMock);
			
			Assert.assertEquals('It should say hah', 'haha', mock.moo);
			Assert.assertEquals('It should say whut', 'whut', mock.lmao);
		}
		
		[Test]
		public function getInstanceReturnsANewInstanceIfNotSingleTon():void
		{
			injector.map(String, 'lmao').toValue('whut')
			injector.map(String, 'moo').toValue('haha');
			injector.map(RobotLegsAssuptionsMock);
			
			var mock:RobotLegsAssuptionsMock = injector.getInstance(RobotLegsAssuptionsMock);
			var differentMock:RobotLegsAssuptionsMock = injector.getInstance(RobotLegsAssuptionsMock);
			
			Assert.assertFalse('The objects should not be equal under strict equality', mock === differentMock);
			
			injector.map(RobotLegsAssuptionsMock).asSingleton();
			mock = injector.getInstance(RobotLegsAssuptionsMock);
			differentMock = injector.getInstance(RobotLegsAssuptionsMock);

			Assert.assertTrue('The objects should now be equal under strict equality', mock === differentMock);
		}

	}
}
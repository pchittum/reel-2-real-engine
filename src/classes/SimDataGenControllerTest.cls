@isTest
private class SimDataGenControllerTest {
	
	@isTest static void test_method_one() {
		// Implement test code
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
	@isTest static void noMoreUsersTestTrue() {
		// Implement test code
		SimDataGenController ctrl = new SimDataGenController();
		ctrl.users.add(new SimDataGenController.UserTracker());
		ctrl.users.add(new SimDataGenController.UserTracker());
		ctrl.users.add(new SimDataGenController.UserTracker());
		ctrl.users.get(0).isCreated = true;
		ctrl.users.get(1).isCreated = true;
		ctrl.users.get(2).isCreated = true;
		System.assert(ctrl.noMoreUsers(ctrl.users),'Test for more users reports false when should be true.');
	}
	@isTest static void noMoreUsersTestFalse() {
		// Implement test code
		SimDataGenController ctrl = new SimDataGenController();
		ctrl.users.add(new SimDataGenController.UserTracker());
		ctrl.users.add(new SimDataGenController.UserTracker());
		ctrl.users.add(new SimDataGenController.UserTracker());
		ctrl.users.get(0).isCreated = true;
		ctrl.users.get(1).isCreated = true;
		System.assert(!ctrl.noMoreUsers(ctrl.users),'Test for more users reports true when should be false.');
	}
}
public with sharing class SimDataGenController {

	public Id profileId {get;set;}
	public List<UserTracker> users {get;set;}
	public Map<String,Account> accounts {get;set;}
	public transient List<Opportunity> newOpportunities {get;set;}
	private Integer userIndex = 0;
	private boolean isTestRun = false;

	public SimDataGenController() {

		users = new List<UserTracker>();
		accounts = new Map<String,Account>();

		users.add(new UserTracker(SimDataGenerator.makeUser(SimDataGenerator.kHugoFirst,SimDataGenerator.kHugoLast,SimDataGenerator.kHugoUser)));
		users.add(new UserTracker(SimDataGenerator.makeUser(SimDataGenerator.kDottFirst,SimDataGenerator.kDottLast,SimDataGenerator.kDottUser)));
		users.add(new UserTracker(SimDataGenerator.makeUser(SimDataGenerator.kMillyFirst,SimDataGenerator.kMillyLast,SimDataGenerator.kMillyUser)));
		users.add(new UserTracker(SimDataGenerator.makeUser(SimDataGenerator.kLorraineFirst,SimDataGenerator.kLorraineLast,SimDataGenerator.kLorraineUser), true));

		String runMode = ApexPages.currentPage().getParameters().get('mode');
		isTestRun = runMode != null && runMode.equals('test');
	}

	public PageReference assignPermissionSet(){

		List<PermissionSet> sets = [SELECT Id FROM PermissionSet WHERE Name = 'Wonderforce'];

		if(!sets.isEmpty()){

			Integer count = [SELECT COUNT() FROM PermissionSetAssignment WHERE PermissionSetId = :sets[0].Id AND AssigneeId = :UserInfo.getUserId()];

			if(count == 0){
				PermissionSetAssignment assign = new PermissionSetAssignment(PermissionSetId=sets[0].Id, AssigneeId=UserInfo.getUserId());
				insert assign;
			}

		}

		return null;
	}

	public PageReference createGameVars(){

	    CollaborationGroup g = new CollaborationGroup(Name='Memtape Research', CollaborationType='Public');
	    g.OwnerId = UserInfo.getUserId() ;
	    insert g;

	    Beacon.saveSetting('TheGroupId', g.Id);

	    // Not nice should check we have the right user but it will do for now
	    Beacon.saveSetting('TheGuideId', this.users[3].usr.Id);

	    Beacon.registerAdventure(new AdventureFromFile('WorldTourAdventure'));

    	return null;

	}

	public PageReference generateData(){ //invoked by button
		return Page.sim_page_datagen_generic;
	}

	public PageReference populateGenericData(){ //step 1: data not related to any of game users
		//TODO: add cleanup code
		accounts = SimDataGenerator.createSimAccounts();

		return Page.sim_page_datagen_usercreate;
	}

	public PageReference createUser(){ //step 2: to repeate once per user
		//TODO: could add logic to use existing if already created.
		//kind of an important one as we do not delete users...ever!

		//check for Apex test exec or if mode=test is in URL at start of process
		//if so, mock the user ID with current user ID
		if (Test.isRunningTest() || isTestRun){
			users.get(userIndex).usr.Id = UserInfo.getUserId(); 
		} else {
			//insert the user
			//TODO: either make active or insert new
			users.get(userIndex).usr = SimDataGenerator.makeUser(users.get(userIndex).usr);
			if (users.get(userIndex).usr.Id == null) {
				insert users.get(userIndex).usr;
			} else {
				users.get(userIndex).usr.isActive = true;
				update users.get(userIndex).usr;
			}
			if (users.get(userIndex).usr.Id == null) throw new SimDataGenerator.SimDataGenException('You must have a user id to proceed');

		}

		return Page.sim_page_datagen_userrecs;
	}

	public PageReference createUserRecords(){ //step 3: repeat once per user records owned by this user
		try {

			newOpportunities = SimDataGenerator.getSimOpportunities(users.get(userIndex).usr, accounts);

			insert newOpportunities;
		} catch(Exception e){
			System.debug(e);
			ApexPages.addMessages(e);
			return null;
		}

		return Page.sim_page_datagen_userdeactivate;
	}

	public PageReference deactivateUser(){ //step 4: repeat once per user deactivate the user to preserve license count
		if (!Test.isRunningTest() && !isTestRun && !users.get(userIndex).leaveActive){
			SimDataGenerator.deactivateUser(users.get(userIndex).usr);
		}

		if (!users.isEmpty()) 
			users.get(userIndex++).isCreated = true;
		
		return Page.sim_page_datagen_checkdone;
	}

	public PageReference checkComplete(){
		PageReference resultPage;
		if (noMoreUsers(users)) { //we done
			resultPage = Page.sim_page_datagen_result;
			//block of code to do any cleanup activities or wrap-up data gen
		} else { 
			//play it again sam
			resultPage = Page.sim_page_datagen_usercreate;
		}
		return resultPage;
	}

	public Integer getUserCount(){
		return users.size();
	}

	public Integer getCurrentUserNumber(){
		return users.size() > 0 ? userIndex + 1 : 0;
	}

	@TestVisible
	private boolean noMoreUsers(List<UserTracker> userList){
		boolean noMore = true;
		for (UserTracker u : userList){
			if (!u.isCreated){
				noMore = false;
			}
		}

		return noMore;
	}

	public class UserTracker {
		public boolean isCreated {get;set;}
		public boolean leaveActive {get; set;}
		public User usr {get;set;}

		public UserTracker(){
			this(new User());
		}

		public UserTracker(User u){
			isCreated = false;
			leaveActive = false;
			usr = u;
		}

		public UserTracker(User u, Boolean leaveActive){
			isCreated = false;
			leaveActive = leaveActive;
			usr = u;
		}

	}
}
public class SimDataGenerator {

	public static final String kAccountSputter = 'Sputter340';
	public static final String kAccountNW = 'Northwind';
	public static final String kHugoFirst = 'Hugo';
	public static final String kHugoLast = 'Wolke';
	public static final String kHugoUser = 'hugo@memtape.com';
	public static final String kMillyFirst = 'Milly';
	public static final String kMillyLast = 'Appleton';
	public static final String kMillyUser = 'milly@memtape.com';
	public static final String kDottFirst = 'Dott';
	public static final String kDottLast = 'Minervudottir';
	public static final String kDottUser = 'dott@wonderforce.com';
	public static Id kProfileId; 

	static {
		kProfileId = [select id from Profile where Name = 'Standard User'].Id;
	}

	public static void generateData(){
		Map<String,Account> acctsMap = createSimAccounts();

		System.debug(acctsMap.values());

		createUsersAndData(acctsMap);
		//delete acctsMap.values();

	}

	/**
	This method may seem overly complex. Trying to work within the bounds of 2 
	Salesforce user lincenses. The player is already using 1. We have to generate data
	and have it associated to 3 new users. Process is
	- Create User
	- Create Data assigned to user (in this case opportunities)
	- Set User as inactive
	- Repeat for each user

	Yes...this sucks, but the only way to have any chance of success

	Started to look at making this less copy/paste, but decided forget it...it is ugly 
	static data creation code. Not pretty. 
	*/
	public static void createUsersAndData(Map<String,Account> acctMap){

		//hugo's stuff
		User hugoU = makeUser(kHugoFirst,kHugoLast,kHugoUser);
		insert hugoU;

		List<Opportunity> hugoOpps = getSimOpportunities(hugoU, acctMap);
		insert hugoOpps;

		deactivateUser(hugoU);

		//dott's stuff
		User dottU = makeUser(kDottFirst,kDottLast,kDottUser);
		insert dottU;

		List<Opportunity> dottOpps = getSimOpportunities(dottU, acctMap);

		deactivateUser(dottU);

		//milly's stuff
		User millyU = makeUser(kMillyFirst,kMillyLast,kMillyUser);
		insert millyU;

		List<Opportunity> millyOpps = getSimOpportunities(millyU, acctMap);

		deactivateUser(millyU);

	}

	public static List<Opportunity> getSimOpportunities(User ownerUser, Map<String,Account> acctMap){

		System.debug(acctMap);

		List<Opportunity> newOpps = new List<Opportunity>();
		//TODO: fix amounts and quantities
		if (ownerUser.alias.equalsIgnoreCase('hugo')){
			newOpps.add(new Opportunity(Name=acctMap.values().get(4).Name+' 4 Units',StageName='Closed Won',Amount=4000,   Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=4,   LeadSource='Existing Business',CloseDate=Date.newInstance(2013,04,10),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2013,04,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2013,05,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2013,06,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Customer'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Customer'     ,CloseDate=Date.newInstance(2013,07,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2013,08,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2013,09,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2013,10,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2013,11,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2013,12,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.values().get(4).Name+' 6 Units',StageName='Closed Won',Amount=6000,   Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=6,   LeadSource='Existing Business',CloseDate=Date.newInstance(2014,01,10),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,01,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,02,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2014,03,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,04,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2014,05,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,06,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2014,07,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,08,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2014,09,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2014,10,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,11,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='Existing Business',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='Existing Business',CloseDate=Date.newInstance(2014,12,15),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.values().get(4).Name+' 4 Units',StageName='Closed Won',Amount=6000,   Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=4,   LeadSource='New Business'     ,CloseDate=Date.newInstance(2015,01,10),AccountId=acctMap.get(kAccountNW).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountNW).Name+' 1000 Units',StageName='Closed Won',Amount=1000000,Type='New Business'     ,OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='New Business'     ,CloseDate=Date.newInstance(2015,01,15),AccountId=acctMap.get(kAccountNW).Id));

		} else if (ownerUser.alias.equalsIgnoreCase('dott')){
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountSputter).Name+' 1000 Units',StageName='Closed Won',Amount=50000,Type='Purchase',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='',CloseDate=Date.newInstance(2014,03,21),AccountId=acctMap.get(kAccountSputter).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountSputter).Name+' 1000 Units',StageName='Closed Won',Amount=50000,Type='Purchase',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='',CloseDate=Date.newInstance(2014,04,23),AccountId=acctMap.get(kAccountSputter).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountSputter).Name+' 1000 Units',StageName='Closed Won',Amount=50000,Type='Purchase',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='',CloseDate=Date.newInstance(2014,05,19),AccountId=acctMap.get(kAccountSputter).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountSputter).Name+' 1000 Units',StageName='Closed Won',Amount=50000,Type='Purchase',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='',CloseDate=Date.newInstance(2014,06,21),AccountId=acctMap.get(kAccountSputter).Id));
			newOpps.add(new Opportunity(Name=acctMap.get(kAccountSputter).Name+' 1000 Units',StageName='Closed Won',Amount=50000,Type='Purchase',OwnerId=ownerUser.Id,TotalOpportunityQuantity=1000,LeadSource='',CloseDate=Date.newInstance(2014,07,17),AccountId=acctMap.get(kAccountSputter).Id));
		} else {

			List<String> stageNames = new List<String>{'Closed Won','Closed Lost','Value Proposition','Negotiation/Review','Proposal/Price Quote','Needs Analysis'};
			List<String> typeNames = new List<String>{'New Business','Existing Business'};
			List<String> sourceNames = new List<String>{'Phone Inquiry','Word of Mouth','Partner','External Referral','Advertisement','Needs Analysis'};
			List<Integer> monthNums = new List<Integer>{1,2,3,4,5,6,7,8,9,10,11,12};
			List<Integer> years = new List<Integer>{2013,2014};
			

			for (Integer i = 0; i < 9; i++){
				for (Account a : acctMap.values()){
					if (a.Name.equalsIgnoreCase(kAccountSputter) || a.Name.equalsIgnoreCase(kAccountNW)) continue;
					Integer numUnits = Integer.valueof(Math.floor(Math.random() * 100));

					newOpps.add(new Opportunity(Name=a.Name+' - ' + numUnits + ' Units',StageName=stageNames.get(Math.mod(numUnits,stageNames.size())),Amount=numUnits * 1000,Type=typeNames.get(Math.mod(numUnits,typeNames.size())),OwnerId=ownerUser.Id,TotalOpportunityQuantity=numUnits,LeadSource=sourceNames.get(Math.mod(numUnits,sourceNames.size())),CloseDate=Date.newInstance(years.get(Math.mod(numUnits,years.size())),monthNums.get(Math.mod(numUnits,monthNums.size())),15),AccountId=a.Id));

				}
			}
		}
		return newOpps;
	}

	public static Map<String,Account> createSimAccounts(){
		Account northwind = new Account(name=kAccountNW);
		Account sputter340 = new Account(name=kAccountSputter);
		Account acct1 = new Account(name='First Amalgamated');
		Account acct2 = new Account(name='Crocker Bank');
		Account acct3 = new Account(name='BCP Chem');
		Account acct4 = new Account(name='FSAB');
		Account acct5 = new Account(name='Daxell Corp');
		Account acct6 = new Account(name='Laemle Turnkey Solutions');
		Account acct7 = new Account(name='Pack Flat');
		Account acct8 = new Account(name='Corwin Tully, LLC.');

		//new List for purposes of the save
		Map<String,Account> acctMap = new Map<String,Account>();

		acctMap.put(sputter340.Name,sputter340);
		acctMap.put(northwind.Name,northwind);
		acctMap.put(acct1.Name,acct1);
		acctMap.put(acct2.Name,acct2);
		acctMap.put(acct3.Name,acct3);
		acctMap.put(acct4.Name,acct4);
		acctMap.put(acct5.Name,acct5);
		acctMap.put(acct6.Name,acct6);
		acctMap.put(acct7.Name,acct7);
		acctMap.put(acct8.Name,acct8);

		insert acctMap.values();

		return acctMap;
	}

	public static User makeUser(String first, String last, String uNameRoot){
		User newUser = new User();
		//newUser.ProfileId = kProfileId;
		newUser.FirstName = first;
		newUser.LastName = last;
		newUser.Username = uNameRoot;
		//newUser.email = UserInfo.getUserEmail();
		//newUser.alias = first.toLowercase();
		//newUser.EmailEncodingKey = 'ISO-8859-1';
		//newUser.LocaleSidKey = 'en_GB';
		//newUser.TimeZoneSidKey = 'Europe/London'; 
		//newUser.LanguageLocaleKey = 'en_US';

		return makeUser(newUser);
	}

	public static User makeUser(User newUser){

		if (newUser.FirstName == null || newUser.LastName == null || newUser.Username == null){
			throw new SimDataGenException('The makeUser method did not have correct User information');
		}

		List<User> dbUser = [select Id,ProfileId,UserName,FirstName,
									LastName,Email,Alias,EmailEncodingKey,
									LocaleSidKey,LanguageLocaleKey,TimeZoneSidKey
							 from User
							 where Username = : UserInfo.getOrganizationId() + newUser.Username];

		if (dbUser.size() > 0){
			newUser = dbUser.get(0);
		} else {

			newUser.ProfileId = kProfileId;
			//newUser.FirstName = first;
			//newUser.LastName = last;
			//the line below ensures that username is unique in each org
			newUser.Username = UserInfo.getOrganizationId() + newUser.Username;
			newUser.email = UserInfo.getUserEmail();
			newUser.alias = newUser.FirstName.toLowercase();
			newUser.EmailEncodingKey = 'ISO-8859-1';
			newUser.LocaleSidKey = 'en_GB';
			newUser.TimeZoneSidKey = 'Europe/London'; 
			newUser.LanguageLocaleKey = 'en_US';
		}
		
		return newUser;
	}

	public static void deactivateUser(Id userId){
		User u = new User(Id=userId);
		deactivateUser(u);
	}

	public static void deactivateUser(User usr){
		if (usr.Id == UserInfo.getUserId()) throw new SimDataGenException('No! Don\'t deactivate yourself!');
		usr.isActive = false;
		update usr; 
	}

	public class SimDataGenException extends Exception {}
}
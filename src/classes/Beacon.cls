global class Beacon {

	global static Boolean registerAdventure(IAdventure adventure){

		String className = adventure.getFullyQualifiedClass();
		Integer settingKey = className.hashCode();

		if(className == null)
			return false;

		Adventure__c l = Adventure__c.getInstance(String.valueOf(settingKey));
		if(l != null)
			return false;

		l = new Adventure__c(name=String.valueOf(settingKey), Class_Name__c=className, Is_File_Based__c=adventure.isFileBased());
		insert l;

		return true;
	}

	global static String readSetting(String name){

		GeneralSetting__c setting = GeneralSetting__c.getInstance(name);
		
		if(setting == null)
			return null;
		else
			return setting.value__c;

	}

	global static void saveSetting(String name, String value){

		GeneralSetting__c setting = GeneralSetting__c.getInstance(name);

		if(setting == null)
			setting = new generalSetting__c(Name = name);

		setting.value__c = value;

		upsert setting;

	}

	global static void deleteSetting(String name){

		GeneralSetting__c setting = GeneralSetting__c.getInstance(name);

		if(setting != null)
			delete setting;

	}

	global static void markQuestAnswered(IQuest quest){
		Quest_Post__c qp = Quest_Post__c.getInstance(AdventureWrapper.settingKey(quest.getFullyQualifiedClass()));
		if(qp != null){
			qp.Answered__c = true;
			update qp;
		}

	}

}
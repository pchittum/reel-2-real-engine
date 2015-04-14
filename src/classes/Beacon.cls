global class Beacon {

	global static Boolean registerLevel(ILevel level){

		String className = level.getFullyQualifiedClass();
		Integer settingKey = className.hashCode();

		if(className == null)
			return false;

		Level__c l = Level__c.getInstance(String.valueOf(settingKey));
		if(l != null)
			return false;

		l = new Level__c(name=String.valueOf(settingKey), Class_Name__c=className);
		insert l;

		return true;
	}

	global static String readSetting(String name){

		GeneralSetting__c setting = GeneralSetting__c.getInstance(UserInfo.getUserId() + name);
		
		if(setting == null)
			return null;
		else
			return setting.value__c;

	}

	global static void saveSetting(String name, String value){

		GeneralSetting__c setting = GeneralSetting__c.getInstance(UserInfo.getUserId() + name);

		if(setting == null)
			setting = new generalSetting__c(Name = UserInfo.getUserId() + name);

		setting.value__c = value;

		upsert setting;

	}

	global static void deleteSetting(String name){

		GeneralSetting__c setting = GeneralSetting__c.getInstance(UserInfo.getUserId() + name);

		if(setting != null)
			delete setting;

	}

	global static void markQuestionAnswered(IQuestion question){
		Question_Post__c qp = Question_Post__c.getInstance(LevelWrapper.settingKey(question.getFullyQualifiedClass()));
		if(qp != null){
			qp.Answered__c = true;
			update qp;
		}

	}

}
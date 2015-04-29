public class AdventureWrapper {

	public IAdventure AdventureDetails {get; private set;}
	public Adventure__c AdventureSettings {get; private set;}

	public AdventureWrapper(){}

	public AdventureWrapper(IAdventure AdventureDetails) {
		this.AdventureDetails = AdventureDetails;
		this.AdventureSettings = Adventure__c.getInstance(AdventureWrapper.settingKey(AdventureDetails.getFullyQualifiedClass()));
	}

	public AdventureWrapper(Adventure__c AdventureSettings) {
		this.AdventureSettings = AdventureSettings;
		String ns = '';
		String cls = '';
		if(this.AdventureSettings.Class_Name__c.contains('.')){
			ns = this.AdventureSettings.Class_Name__c.split('\\.')[0];
			cls = this.AdventureSettings.Class_Name__c.split('\\.')[1];
		}else{
			cls = this.AdventureSettings.Class_Name__c;
		}
		
		try{
			this.AdventureDetails = (IAdventure)Type.forName(ns, cls).newInstance();
		}catch(Exception ex){
			throw new ChannelException('AdventureSettings ' + this.AdventureSettings.Class_Name__c);
		}
	}

	public AdventureWrapper(String AdventureSettingsName){
		this.AdventureSettings = Adventure__c.getInstance(AdventureSettingsName);
		String ns = '';
		String cls = '';
		if(this.AdventureSettings.Class_Name__c.contains('.')){
			ns = this.AdventureSettings.Class_Name__c.split('\\.')[0];
			cls = this.AdventureSettings.Class_Name__c.split('\\.')[1];
		}else{
			cls = this.AdventureSettings.Class_Name__c;
		}

		try{
			this.AdventureDetails = (IAdventure)Type.forName(ns, cls).newInstance();
		}catch(Exception ex){
			throw new ChannelException('AdventureSettingsName ' + this.AdventureSettings.Class_Name__c);
		}
	}

	public IQuest getCurrentQuest(){

		Quest_Post__c qp;

		system.debug('this.AdventureSettings.Current_Quest__c ' + this.AdventureSettings.Current_Quest__c);

		if(this.AdventureSettings.Current_Quest__c == null){

			String classname;

			if(this.isFileBased){
				classname = ((IAdventure)this.AdventureDetails).firstFileName();
			}else{
				classname = this.AdventureDetails.getFirstQuest().getFullyQualifiedClass();
			}

			qp = new Quest_Post__c(name=AdventureWrapper.settingKey(classname), Class_Name__c=classname);
			insert qp;

			this.AdventureSettings.Current_Quest__c = qp.name;
			update this.AdventureSettings;

		}else{
			qp = Quest_Post__c.getInstance(this.AdventureSettings.Current_Quest__c);
		}

		IQuest iq;

		if(this.isFileBased){
			iq = new QuestFromFile(qp.Class_Name__c);
		}else{
			String ns = '';
			String cls = '';
			if(qp.Class_Name__c.contains('.')){
				ns = qp.Class_Name__c.split('\\.')[0];
				cls = qp.Class_Name__c.split('\\.')[1];
			}else{
				cls = qp.Class_Name__c;
			}

			iq = (IQuest)Type.forName(ns, cls).newInstance();
		}

		return iq;

	}

	public IQuest getNextQuest(){

		IQuest newQuest = getcurrentQuest().getNextQuest();
		system.debug('newq ' + newQuest);

		if(newQuest != null){
			String classname = newQuest.getFullyQualifiedClass();
			Quest_Post__c qp = Quest_Post__c.getInstance(AdventureWrapper.settingKey(classname));
			if(qp == null){
			 	qp = new Quest_Post__c(name=AdventureWrapper.settingKey(classname), Class_Name__c=classname);
			 	insert qp;
			}

			this.AdventureSettings.Current_Quest__c = qp.name;
			update this.AdventureSettings;

			return newQuest;
		}else{
			return null;
		}

	}

	public Boolean getQuestStarted(){

		Quest_Post__c qp = getCurrentQuestSettings();
		if(qp == null)
			return false;
		else
			return qp.Started__c;

	}

	public Quest_Post__c getCurrentQuestSettings(){

		IQuest q = getCurrentQuest();
		if(q == null)
			return null;

		system.debug('q ' + q);
		system.debug('qf ' + q.getFullyQualifiedClass());


		return Quest_Post__c.getInstance(AdventureWrapper.settingKey(q.getFullyQualifiedClass()));

	}

	public static String settingKey(String fullyQualifiedClassName){
		return String.valueOf(fullyQualifiedClassName.toLowerCase().hashCode());
	}

	private Boolean isFileBased{
		get{
			return this.AdventureDetails.isFileBased();
		}
	}
}
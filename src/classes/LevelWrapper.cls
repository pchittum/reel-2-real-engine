public class LevelWrapper {

	public ILevel levelDetails {get; private set;}
	public Level__c levelSettings {get; private set;}

	public LevelWrapper(){}

	public LevelWrapper(ILevel levelDetails) {
		this.levelDetails = levelDetails;
		this.levelSettings = Level__c.getInstance(LevelWrapper.settingKey(levelDetails.getFullyQualifiedClass()));
	}

	public LevelWrapper(Level__c levelSettings) {
		this.levelSettings = levelSettings;
		String ns = '';
		String cls = '';
		if(this.levelSettings.Class_Name__c.contains('.')){
			ns = this.levelSettings.Class_Name__c.split('\\.')[0];
			cls = this.levelSettings.Class_Name__c.split('\\.')[1];
		}else{
			cls = this.levelSettings.Class_Name__c;
		}
		
		try{
			this.levelDetails = (Ilevel)Type.forName(ns, cls).newInstance();
		}catch(Exception ex){
			throw new ChannelException('levelSettings ' + this.levelSettings.Class_Name__c);
		}
	}

	public LevelWrapper(String levelSettingsName){
		this.levelSettings = Level__c.getInstance(levelSettingsName);
		String ns = '';
		String cls = '';
		if(this.levelSettings.Class_Name__c.contains('.')){
			ns = this.levelSettings.Class_Name__c.split('\\.')[0];
			cls = this.levelSettings.Class_Name__c.split('\\.')[1];
		}else{
			cls = this.levelSettings.Class_Name__c;
		}

		try{
			this.levelDetails = (Ilevel)Type.forName(ns, cls).newInstance();
		}catch(Exception ex){
			throw new ChannelException('levelSettingsName ' + this.levelSettings.Class_Name__c);
		}
	}

	public IQuestion getCurrentQuestion(){

		Question_Post__c qp;

		system.debug('this.levelSettings.Current_Question__c ' + this.levelSettings.Current_Question__c);

		if(this.levelSettings.Current_Question__c == null){

			String classname;

			if(this.isFileBased){
				classname = ((ILevelV2)this.levelDetails).firstFileName();
			}else{
				classname = this.levelDetails.getFirstQuestion().getFullyQualifiedClass();
			}

			qp = new Question_Post__c(name=LevelWrapper.settingKey(classname), Class_Name__c=classname);
			insert qp;

			this.levelSettings.Current_Question__c = qp.name;
			update this.levelSettings;

		}else{
			qp = Question_Post__c.getInstance(this.levelSettings.Current_Question__c);
		}

		IQuestion iq;

		if(this.isFileBased){
			iq = new QuestionFromFile(qp.Class_Name__c);
		}else{
			String ns = '';
			String cls = '';
			if(qp.Class_Name__c.contains('.')){
				ns = qp.Class_Name__c.split('\\.')[0];
				cls = qp.Class_Name__c.split('\\.')[1];
			}else{
				cls = qp.Class_Name__c;
			}

			iq = (IQuestion)Type.forName(ns, cls).newInstance();
		}

		return iq;

	}

	public IQuestion getNextQuestion(){

		IQuestion newQuestion = getcurrentQuestion().getNextQuestion();
		system.debug('newq ' + newQuestion);

		if(newQuestion != null){
			String classname = newQuestion.getFullyQualifiedClass();
			Question_Post__c qp = new Question_Post__c(name=LevelWrapper.settingKey(classname), Class_Name__c=classname);
			insert qp;

			this.levelSettings.Current_Question__c = qp.name;
			update this.levelSettings;

			return newQuestion;
		}else{
			return null;
		}

	}

	public Boolean getQuestionStarted(){

		Question_Post__c qp = getCurrentQuestionSettings();
		if(qp == null)
			return false;
		else
			return qp.Started__c;

	}

	public Question_Post__c getCurrentQuestionSettings(){

		IQuestion q = getCurrentQuestion();
		if(q == null)
			return null;

		system.debug('q ' + q);
		system.debug('qf ' + q.getFullyQualifiedClass());


		return Question_Post__c.getInstance(LevelWrapper.settingKey(q.getFullyQualifiedClass()));

	}

	public static String settingKey(String fullyQualifiedClassName){
		return String.valueOf(fullyQualifiedClassName.toLowerCase().hashCode());
	}

	private Boolean isFileBased{
		get{
			if(this.levelDetails instanceOf ILevelv2){
				return ((ILevelV2)this.levelDetails).isFileBased();
			}else{
				return false;
			}
		}
	}
}
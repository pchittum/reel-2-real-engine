public with sharing class BeaconHomeController {
	
	public BeaconHomeController() {

		pageStatus = 'LEVELS';
	}

	public String creditsStuff {get; set;}
	public String pageStatus {get; set;}
	public String currentLevelName {get; set;}

	public Integer levelCount{
		get{
			return Level__c.getAll().size();
		}
	}

	public List<LevelWrapper> levels{
		get{

			if(levels == null || levels.isEmpty()){
				levels = new List<LevelWrapper>();

				for(Level__c level : Level__c.getAll().values()){
					levels.add(new LevelWrapper(level));
				}
			}

			return levels;

		}
		private set;
	}

	public LevelWrapper currentLevel{
		get{
			if(currentLevel == null){
				currentLevel = new LevelWrapper(currentLevelName);
			}

			return currentLevel;
		}
		private set;
	}

	public String soundTrackSource{
		get{
			if(currentLevel.levelDetails.getSoundTrackId() != null){

				List<StaticResource> resources = [SELECT Name, ContentType, NamespacePrefix, SystemModstamp FROM StaticResource WHERE Id = :currentLevel.levelDetails.getSoundTrackId()];
				if(resources.isEmpty())
					return null;

				return '/resource/' + resources[0].SystemModstamp.getTime() + '/' + (resources[0].NamespacePrefix == null ? '' : resources[0].NamespacePrefix + '__') + resources[0].Name;
			}else if(currentLevel.levelDetails.getSoundTrackUrl() != null){
				return currentLevel.levelDetails.getSoundTrackUrl();
			}

			return null;
		}
	}

	public String InPlayName{
		get{
			if(InPlayName == null){
				List<Level__c> levels = [SELECT Name FROM Level__c WHERE In_Play__c = true];
				if(levels.isEmpty())
					InPlayName = null;
				else
					InPlayName = levels[0].Name;
			}

			return InPlayName;
		}
		private set;
	}

	public PageReference StartLevel(){

		pageStatus = 'INLEVEL';

		if(!currentLevel.levelSettings.In_Play__c){
			currentLevel.levelSettings.In_Play__c = true;
			currentLevel.levelSettings.Last_Started__c = System.now();
			currentLevel.levelSettings.Attempts__c++;
			currentLevel.getCurrentQuestionSettings();
			update currentLevel.levelSettings;
		}


		return null;
	}

	public PageReference Reset(){

		delete [SELECT Id FROM Question_Post__c];

		currentLevel.levelSettings.In_Play__c = false;
		currentLevel.levelSettings.Current_Question__c = null;
		InPlayName = null;
		update currentLevel.levelSettings;		

		delete [SELECT Id FROM FeedItem WHERE ParentId = :Beacon.readSetting('TheGroupId')];

		return null;
	}

	public PageReference startQuestion(){

		Question_Post__c qp = currentLevel.getCurrentQuestionSettings();
		qp.Started__c = true;
		update qp;


		ChatterEvent ce = currentLevel.getCurrentQuestion().getFirstPost();

		if(ce.PostDetails != null){
			ce.PostDetails.CreatedById = Beacon.readSetting('TheGuideId');
			ce.PostDetails.ParentId = Beacon.readSetting('TheGroupId');

			insert ce.postDetails;

			qp.Post_Id__c = ce.PostDetails.Id;
			update qp;
		}


		return null;
	}

	public Id chatterTarget{
		get{
			return (Id)Beacon.readSetting('TheGroupId');
		}
	}

	private static List<AudioEvent> getAudioEvents(String levelName, Integer lastCheckLevel, Integer thisCheckLevel, Integer lastCheckQuestion, Integer thisCheckQuestion){

		LevelWrapper lvl = new LevelWrapper(levelName);
		List<AudioEvent> events = new List<AudioEvent>();

		// Level based timed events
		List<AudioEvent> levelAudioEvents = lvl.levelDetails.getAudioEvents();

		if(levelAudioEvents != null && !levelAudioEvents.isEmpty()){

			for(AudioEvent ae : lvl.levelDetails.getAudioEvents()){

				if(ae.Start > lastCheckLevel && ae.Start <= thisCheckLevel){
					events.add(ae);
				}

			}
		}

		// Question based timed events
		List<AudioEvent> questionAudioEvents = lvl.levelDetails.getAudioEvents();

		if(questionAudioEvents != null && !questionAudioEvents.isEmpty()){

			for(AudioEvent ae : lvl.getCurrentQuestion().getAudioEvents()){

				if(ae.Start > lastCheckQuestion && ae.Start <= thisCheckQuestion){
					events.add(ae);
				}

			}
		}


		// Random events pushed into settings as they are needed
		for(Audio_Event__c aeSetting : Audio_Event__c.getAll().values()){

			AudioEvent ae = new AudioEvent();
			if(aeSetting.ResourceUrl__c != null)
				ae.ResourceUrl = aeSetting.ResourceUrl__c;

			if(aeSetting.Resource_Id__c != null)
				ae.updateUrlFromId(aeSetting.Resource_Id__c);

			ae.VolumePercentage = aeSetting.Volume_Percentage__c;
			ae.Channel = Integer.valueOf(aeSetting.Channel__c);

			events.add(ae);

		}

		delete Audio_Event__c.getAll().values();
		
		return events;

	}

	@RemoteAction
	public static Events runEvents(String levelName, Integer lastCheckLevel, Integer thisCheckLevel, Integer lastCheckQuestion, Integer thisCheckQuestion){

		Events oeRet = new Events();
		LevelWrapper lvl = new LevelWrapper(levelName);

		//Chatter events - time based
		List<FeedItem> feedItems = new List<FeedItem>();
		for(ChatterEvent ce : lvl.levelDetails.getChatterEvents()){
			if(ce.Start > lastCheckLevel && ce.Start <= thisCheckLevel){
				oeRet.RefreshChatter = true;
				if(ce.PostDetails.CreatedById == null || ce.PostDetails.CreatedById == UserInfo.getUserId())
					ce.PostDetails.CreatedById = Beacon.readSetting('TheGuideId');

				feedItems.add(ce.PostDetails);
			}
		}
		insert feedItems;

		// There may be new items in the feed from other sources
		if(lvl.levelSettings.Update_Chatter__c){
			oeRet.RefreshChatter = true;
			lvl.levelSettings.Update_Chatter__c = false;
			update lvl.levelSettings;
		}

		// Have they successfully answered the question?
		if(lvl.getCurrentQuestionSettings().Answered__c){
			
			oeRet.CurrentQuestionAnswered = true;
			if(lvl.getCurrentQuestion() instanceof IQuestionV3){
				IQuestionV3 q3 = (IQuestionV3)lvl.getCurrentQuestion();
				oeRet.CorrectAnswerAudio = q3.getCorrectAnswerAudioClips();
			}

			IQuestion q = lvl.getNextQuestion();

			if(q == null)
				oeRet.AllQuestionsAnswered = true;

		}

		// Populate audio events
		oeRet.AudioEvents = getAudioEvents(levelName, lastCheckLevel, thisCheckLevel, lastCheckQuestion, thisCheckQuestion);

		system.debug('oeRet ' + oeRet);

		return oeRet;
	}

	public PageReference startTimerExpired(){
		creditsStuff = 'Tape dequeued. You should have been quicker. Here are some credits.';
		pageStatus = 'LEVELEND';
		return null;
	}

	public PageReference playTimerExpired(){
		creditsStuff = 'Find the answers quicker will you? Here are some credits.';
		pageStatus = 'LEVELEND';
		return null;
	}

	public PageReference allCompleted(){
		creditsStuff = 'Yup, that\'s the end. Here are some credits.';
		pageStatus = 'LEVELEND';
		return null;
	}

	public PageReference refresh(){
		currentLevel = null;
		return null;
	}

	public class Events{
		public Boolean RefreshChatter {get; set;}
		public Boolean CurrentQuestionAnswered {get; set;}
		public Boolean AllQuestionsAnswered {get; set;}
		public List<AudioEvent> CorrectAnswerAudio {get; set;}
		public List<AudioEvent> AudioEvents {get; set;}

		public Events(){
			RefreshChatter = false;
			CurrentQuestionAnswered = false;
			AllQuestionsAnswered = false;
			AudioEvents = new List<AudioEvent>();
			CorrectAnswerAudio = new List<AudioEvent>();
		}
	}

}
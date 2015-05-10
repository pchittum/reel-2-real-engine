public with sharing class CreateAdventureController {

	public AdventureFile adventure {get; set;}
	public List<QuestFile> quests {get; set;}
	public Integer questNumber {get; set;}
	public Integer downloadNum {get; set;}

	public String adventureDownloadString {get; set;}
	public String questDownloadString {get; set;}
	//public String contentType {get; set;}

	public CreateAdventureController() {
		adventure = new AdventureFile();
	}

	public PageReference firstQuest() {
		quests = new List<QuestFile>();
		quests.add(new QuestFile());
		questNumber = 0;
		return Page.DefineQuest;
	}

	public PageReference newQuest() {
		setCorrectAudio();
		quests[questNumber].FileName = quests[questNumber].FileName.replace(' ', '_');

		quests.add(new QuestFile());
		questNumber++;
		return Page.DefineQuest;
	}

	public PageReference addAnswer() {
		if(quests[questNumber].Answers == null) {
			quests[questNumber].Answers = new List<QuestFile.Answer>();
		}

		quests[questNumber].Answers.add(new QuestFile.Answer());

		return null;
	}

	public PageReference finish() {
		System.debug('Error?');
		setCorrectAudio();
		System.debug('Error1?' + questNumber);
		quests[questNumber].FileName = quests[questNumber].FileName.replace(' ', '_');
		System.debug('Error2? ' + adventure);
		adventure.FileName = adventure.AdventureName.replace(' ', '_');
		System.debug('Error3?');
		adventure.FirstQuestFileName = quests[0].FileName;
		System.debug('Error4?');
		return Page.AdventureSummary;
	}

	public PageReference downloadAdventureFile() {
		adventureDownloadString = JSON.serializePretty(adventure);
		//contentType = 'text/plain/#' + adventure.FileName + '.json';
		return Page.AdventureFile;
	}

	public PageReference downloadQuestFile() {
		if(downloadNum + 1 < quests.size()) {
			quests[downloadNum].NextQuest = quests[downloadNum + 1].FileName;
		}
		
		//contentType = 'text/plain/#' + quests[downloadNum].FileName + '.json';
		questDownloadString = JSON.serializePretty(quests[downloadNum]);
		return Page.QuestFile;
	}

	private void setCorrectAudio(){
		for(Integer i = 0, j = quests[questNumber].Answers.size(); i < j; i++) {
			quests[questNumber].Answers[i].CorrectAudio = quests[questNumber].Answers[i].AudioStrings.split(',');
		}
	}

}
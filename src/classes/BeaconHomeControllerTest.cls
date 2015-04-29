@isTest
private class BeaconHomeControllerTest {

	private static String AdventureName;

	private static void setup(){

		CollaborationGroup cg = new CollaborationGroup(name='Test Group', CollaborationType='Public');
		insert cg;

		Beacon.saveSetting('TheGuideId', UserInfo.getUserId());
		Beacon.saveSetting('TheGroupId', cg.Id);

		Beacon.registerAdventure(new AdventureTest());
		AdventureName = Adventure__c.getAll().values()[0].Name;
        
		Audio_Event__c ae=  new Audio_Event__c(Name='bob', Channel__c=0, ResourceUrl__c='hello', Volume_Percentage__c=0.5);
		insert ae;
	}

	private static testMethod void testSomething(){

		setup();

		BeaconHomeController con = new BeaconHomeController();

		system.assertEquals('AdventureS', con.pageStatus);
		system.assertEquals(1, con.Adventures.size());

        system.assertEquals(1, con.AdventureCount);

		con.currentAdventureName = AdventureName;

		system.assertNotEquals(null, con.currentAdventure);

        system.assertNotEquals(null, con.RadioClips);


		system.assertEquals(null, con.InPlayName);
		con.StartAdventure();
		system.assertEquals(AdventureName, con.InPlayName);


		con.startQuest();
		List<FeedItem> fis = [SELECT Id FROM FeedItem];
		system.assertEquals(1, fis.size());


		system.assertNotEquals(null, con.chatterTarget);


		system.assertEquals(null, con.startTimerExpired());
		system.assertEquals(null, con.playTimerExpired());
		system.assertEquals(null, con.allCompleted());
		system.assertEquals(null, con.refresh());

		BeaconHomeController.Events evts = BeaconHomeController.runEvents(AdventureName, 0, 0, 10, 0);

		system.assertNotEquals(null, evts);
		system.assertEquals(null, con.currentAdventure.getNextQuest());
		system.assertEquals(true, con.currentAdventure.getQuestStarted());

		FeedComment fc = new FeedComment(FeedItemId=fis[0].Id, CommentBody='right');
		insert fc;


		AudioEvent ae = new AudioEvent('url', 0, 2);
		system.assertEquals(0.5, ae.VolumePercentage);
		system.assertEquals(2, ae.Channel);
		system.assertEquals(0, ae.Start);
		system.assertEquals('url', ae.ResourceUrl);





		ae = new AudioEvent();
		ae = new AudioEvent('hello', 0);
		ae = new AudioEvent((Id)UserInfo.getUserId(), 0);
		ae = new AudioEvent((Id)UserInfo.getUserId(), 0, 0);



		ChatterEvent ce =new ChatterEvent(new FeedItem(), 0);


		Beacon.markQuestAnswered(con.currentAdventure.getCurrentQuest());


		system.assertNotEquals(0, Quest_Post__c.getAll().size());
		con.Reset();
		system.assertEquals(0, Quest_Post__c.getAll().size());

		AdventureWrapper lw = new AdventureWrapper(con.currentAdventure.AdventureDetails);
		Beacon.deleteSetting('TheGroupId');

	}

	private static testMethod void questFile(){

		QuestFile qf = new QuestFile();

		qf.filename = 'hh';
		qf.loadTime = 10;
		qf.playTime = 10;
		qf.loadingText = 'oo';
		qf.question = 'klj';

		QuestFile.Answer ans = new QuestFile.Answer();
		ans.answer = 'll';
		ans.response = 'oo';
		ans.correctAudio = new List<String>{'https://www.dropbox.com/s/nmcgtoj8nl5frxb/cust_s02.mp3?dl=1'};

		qf.answers = new List<QuestFile.Answer>{ans};
		qf.nextQuest = 'TestQuest1';


		QuestFromFile qff = new QuestFromFile(qf);

		system.assertNotEquals(null, qff.getFullyQualifiedClass());
		system.assertNotEquals(null, qff.getLoadTime());
		system.assertNotEquals(null, qff.getPlayTime());
		system.assertNotEquals(null, qff.getAudioEvents());
		system.assertNotEquals(null, qff.getChatterEvents());
		system.assertNotEquals(null, qff.getLoadingText());
		system.assertNotEquals(null, qff.getFirstPost());
		system.assertEquals(null, qff.getWrongAnswerAudioClips());
		system.assertNotEquals(null, qff.getNextQuest());
		system.assertNotEquals(null, qff.getCorrectAnswerAudioClips());



	}

}
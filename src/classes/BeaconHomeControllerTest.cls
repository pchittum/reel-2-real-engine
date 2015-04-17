@isTest
private class BeaconHomeControllerTest {

	private static String levelName;

	private static void setup(){

		CollaborationGroup cg = new CollaborationGroup(name='Test Group', CollaborationType='Public');
		insert cg;

		Beacon.saveSetting('TheGuideId', UserInfo.getUserId());
		Beacon.saveSetting('TheGroupId', cg.Id);

		Beacon.registerLevel(new LevelTest());
		levelName = Level__c.getAll().values()[0].Name;
        
		Audio_Event__c ae=  new Audio_Event__c(Name='bob', Channel__c=0, ResourceUrl__c='hello', Volume_Percentage__c=0.5);
		insert ae;
	}

	private static testMethod void testSomething(){

		setup();

		BeaconHomeController con = new BeaconHomeController();

		system.assertEquals('LEVELS', con.pageStatus);
		system.assertEquals(1, con.levels.size());

        system.assertEquals(1, con.levelCount);

		con.currentLevelName = levelName;

		system.assertNotEquals(null, con.currentLevel);

		system.assertNotEquals(null, con.soundTrackSource);
        system.assertNotEquals(null, con.RadioClips);


		system.assertEquals(null, con.InPlayName);
		con.StartLevel();
		system.assertEquals(levelName, con.InPlayName);


		con.startQuestion();
		List<FeedItem> fis = [SELECT Id FROM FeedItem];
		system.assertEquals(1, fis.size());


		system.assertNotEquals(null, con.chatterTarget);


		system.assertEquals(null, con.startTimerExpired());
		system.assertEquals(null, con.playTimerExpired());
		system.assertEquals(null, con.allCompleted());
		system.assertEquals(null, con.refresh());

		BeaconHomeController.Events evts = BeaconHomeController.runEvents(levelName, 0, 0, 10, 0);

		system.assertNotEquals(null, evts);
		system.assertEquals(null, con.currentLevel.getNextQuestion());
		system.assertEquals(true, con.currentLevel.getQuestionStarted());

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


		Beacon.markQuestionAnswered(con.currentLevel.getCurrentQuestion());


		system.assertNotEquals(0, Question_Post__c.getAll().size());
		con.Reset();
		system.assertEquals(0, Question_Post__c.getAll().size());

		LevelWrapper lw = new LevelWrapper(con.currentLevel.levelDetails);
		Beacon.deleteSetting('TheGroupId');

	}

	private static testMethod void questionFile(){

		QuestionFile qf = new QuestionFile();

		qf.filename = 'hh';
		qf.loadTime = 10;
		qf.playTime = 10;
		qf.loadingText = 'oo';
		qf.question = 'klj';

		QuestionFile.Answer ans = new QuestionFile.Answer();
		ans.answer = 'll';
		ans.response = 'oo';
		ans.correctAudio = new List<String>{'https://www.dropbox.com/s/nmcgtoj8nl5frxb/cust_s02.mp3?dl=1'};

		qf.answers = new List<QuestionFile.Answer>{ans};
		qf.nextQuestion = 'TestQuestion1';


		QuestionFromFile qff = new QuestionFromFile(qf);

		system.assertNotEquals(null, qff.getFullyQualifiedClass());
		system.assertNotEquals(null, qff.getLoadTime());
		system.assertNotEquals(null, qff.getPlayTime());
		system.assertNotEquals(null, qff.getAudioEvents());
		system.assertNotEquals(null, qff.getChatterEvents());
		system.assertNotEquals(null, qff.getLoadingText());
		system.assertNotEquals(null, qff.getFirstPost());
		system.assertEquals(null, qff.getWrongAnswerAudioClips());
		system.assertNotEquals(null, qff.getNextQuestion());
		system.assertNotEquals(null, qff.getCorrectAnswerAudioClips());



	}

}
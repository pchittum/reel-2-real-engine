public class FeedItemTriggerHandler {

	private static Boolean hasRun = false;

	public static void checkForAnswers(List<FeedComment> feedcomments){

		// This doesn't deal with multiple batches
		// But we really shouldn't process more than one comment at a time
		if(hasRun)
			return;

		hasRun = true;

		List<ChatterEvent> responses = new List<ChatterEvent>();

		List<Level__c> levels = [SELECT Name, Class_Name__c, Current_Question__c FROM Level__c WHERE In_Play__c = true];
		if(levels.isEmpty())
			return;

		LevelWrapper level = new LevelWrapper(levels[0]);

		if(level.getCurrentQuestionSettings().Answered__c)
			return;

		Question_Post__c qp = level.getCurrentQuestionSettings();

		for(FeedComment comment : feedComments){

			if(comment.CreatedById != UserInfo.getUserId())
				continue;

			if(qp.Post_Id__c != comment.FeedItemId || qp.Answered__c)
				continue;

			responses.add(level.getCurrentQuestion().readPlayersChatterComment(comment, qp.Question_Id__c));

		}

		List<FeedComment> comments = new List<FeedComment>();
		List<FeedItem> items = new List<FeedItem>();

		for(ChatterEvent ce : responses){
			if(ce == null)
				continue;

			if(ce.PostComment != null){
				ce.PostComment.CreatedById = Beacon.readSetting('TheGuideId');
				comments.add(ce.PostComment);
			}

			if(ce.PostDetails != null){
				ce.PostDetails.CreatedById = Beacon.readSetting('TheGuideId');
				items.add(ce.PostDetails);
			}
		}

		insert comments;
		insert items;

		if(!comments.isEmpty() || !items.isEmpty()){
			level.levelSettings.Update_Chatter__c = true;
			update level.levelSettings;
		}

	}

}
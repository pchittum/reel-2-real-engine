public class FeedItemTriggerHandler {

	private static Boolean hasRun = false;

	public static void checkForAnswers(List<FeedComment> feedcomments){

		// This doesn't deal with multiple batches
		// But we really shouldn't process more than one comment at a time
		if(hasRun)
			return;

		hasRun = true;

		List<ChatterEvent> responses = new List<ChatterEvent>();

		List<Adventure__c> adventures = [SELECT Name, Is_File_Based__c, Class_Name__c, Current_Quest__c FROM Adventure__c WHERE In_Play__c = true];
		if(adventures.isEmpty())
			return;

		AdventureWrapper adventure = new AdventureWrapper(adventures[0]);

		if(adventure.getCurrentQuestSettings().Answered__c)
			return;

		Quest_Post__c qp = adventure.getCurrentQuestSettings();

		for(FeedComment comment : feedComments){

			if(comment.CreatedById != UserInfo.getUserId())
				continue;

			if(qp.Post_Id__c != comment.FeedItemId || qp.Answered__c)
				continue;

			responses.add(adventure.getCurrentQuest().readPlayersChatterComment(comment, qp.Quest_Id__c));

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
			adventure.adventureSettings.Update_Chatter__c = true;
			update adventure.adventureSettings;
		}

	}

}
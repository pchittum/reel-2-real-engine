trigger FeedCommentTrigger on FeedComment (after insert) {

	if(Trigger.isAfter && Trigger.isInsert){
		FeedItemTriggerHandler.checkForAnswers(Trigger.new);
	}

}
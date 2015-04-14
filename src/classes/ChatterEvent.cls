global class ChatterEvent {
	
	global ChatterEvent(FeedItem feedItem, Integer start) {
		this.PostDetails = feedItem;
		this.Start = start;
	}

	global ChatterEvent(FeedItem feedItem) {
		this.PostDetails = feedItem;
	}

	global ChatterEvent(FeedComment comment) {
		this.PostComment = comment;
	}

	global Integer Start {get; set;}
	global FeedItem PostDetails {get; set;}
	global FeedComment PostComment {get; set;}

	global Boolean QuestionAnswered {get; set;}



}
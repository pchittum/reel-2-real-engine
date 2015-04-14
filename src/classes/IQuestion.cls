global interface IQuestion {

	String getFullyQualifiedClass();

	Integer getLoadTime();
	Integer getPlayTime();

	List<AudioEvent> getAudioEvents();
	List<ChatterEvent> getChatterEvents();

	IQuestion getNextQuestion();

	String getLoadingText();

	ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questionId);

	ChatterEvent getFirstPost();



}
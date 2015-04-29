global interface IQuest {

	String getFullyQualifiedClass();

	Integer getLoadTime();
	Integer getPlayTime();

	List<AudioEvent> getAudioEvents();
	List<ChatterEvent> getChatterEvents();

	IQuest getNextQuest();

	String getLoadingText();

	ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questionId);

	ChatterEvent getFirstPost();

	List<AudioEvent> getCorrectAnswerAudioClips();
	List<AudioEvent> getWrongAnswerAudioClips(); // reserved for future use


}
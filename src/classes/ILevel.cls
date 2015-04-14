global interface ILevel {

	
	String getName();
	String getFullyQualifiedClass();
	String getDescription();

	Integer getAllowedDuration();
	Integer getExpectedDuration();

	Id getSoundTrackId();
	String getSoundTrackUrl();

	List<AudioEvent> getAudioEvents();
	List<ChatterEvent> getChatterEvents();

	IQuestion getFirstQuestion();

	ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questionId);

}
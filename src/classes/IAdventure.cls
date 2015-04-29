global interface IAdventure {

	
	String getName();
	String getFullyQualifiedClass();
	String getDescription();

	Integer getAllowedDuration();
	Integer getExpectedDuration();

	String getSoundTrackUrl();

	IQuest getFirstQuest();

	Boolean isFileBased();
	String firstFileName();



}
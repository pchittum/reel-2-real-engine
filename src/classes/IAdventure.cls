global interface IAdventure {

	
	String getName();
	String getFullyQualifiedClass();
	String getDescription();

	Integer getAllowedDuration();

	IQuest getFirstQuest();

	Boolean isFileBased();
	String firstFileName();



}
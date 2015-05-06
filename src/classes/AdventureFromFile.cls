global class AdventureFromFile implements IAdventure{

	private AdventureFile theFile;

	global AdventureFromFile(){}

	public AdventureFromFile(AdventureFile theFile){
		this.theFile = theFile;
	}

	global AdventureFromFile(String fileName){

		List<StaticResource> res = [SELECT Body FROM StaticResource WHERE Name = :filename];

		if(res.isEmpty())
			throw new ChannelException('No matching files');

		try{
			theFile = (AdventureFile)JSON.deserialize(res[0].Body.toString(), AdventureFile.class);
		}catch(Exception ex){
			throw new ChannelException('Read error', ex);			
		}

	}

	public String getName(){
		return theFile.AdventureName;
	}

	public String getFullyQualifiedClass(){
		return theFile.FileName;
	}
	
	public String getDescription(){
		return theFile.Description;
	}

	public Integer getAllowedDuration(){
		return theFile.AllowedDuration;
	}
	
	public IQuest getFirstQuest(){
		return null;
	}

	public Boolean isFileBased(){
		return true;
	}

	public String firstFileName(){
		return theFile.FirstQuestFileName;
	}



}
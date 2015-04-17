public class LevelExample implements ILevel, ILevelv2{

	private static final String CURRENTQUESTION = 'Current Question';

	public String getName(){
		return 'Example Level';
	}

	public String getDescription(){
		return 'Some stuff.';
	}

	public Integer getExpectedDuration(){
		return 15 * 60;
	}

	public Integer getAllowedDuration(){
		return 15 * 60;
	}

	public String getFullyQualifiedClass(){
		return 'LevelExample';
	}

	public Id getSoundTrackId(){
		return null;
	}

	public String getSoundTrackUrl(){
		return 'https://youtu.be/Isid4LLy9g0';
	}

	public List<AudioEvent> getAudioEvents(){

		List<AudioEvent> ret = new List<AudioEvent>();

		return ret;
	}

	public List<ChatterEvent> getChatterEvents(){

		List<ChatterEvent> ret = new List<ChatterEvent>();

		return ret;
	}

	public ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questionId){

		ChatterEvent ret;

		if(chatterComment.CommentBody.Trim() == 'right'){
			return ret;
		}else{
			ret = wrongAnswer();
		}

		return ret;
	}

	public IQuestion getFirstQuestion(){
		return new QuestionExample();
	}

	private ChatterEvent wrongAnswer(){

		ChatterEvent ret = new ChatterEvent(new FeedComment());

		Integer rand = Integer.valueOf(Math.ceil(Math.random() * 2));

		if(rand == 1){
			ret.PostComment.CommentBody = 'Are you sure about that?';
		}else if(rand == 2){
			ret.PostComment.CommentBody = 'With answers like that you should just walk away from the computer, try again.';
		}else{
			ret.PostComment.CommentBody = 'I\'m sorry, I don\'t understand that.';
		}

		return ret;

	}

	public Boolean isFileBased(){
		return true;
	}

	public String firstFileName(){
		return 'Question1';
	}

}
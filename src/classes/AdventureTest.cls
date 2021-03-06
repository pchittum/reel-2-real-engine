@isTest
public class AdventureTest implements IAdventure{

	private static final String CURRENTQUEST = 'Current Quest';

	public String getName(){
		return 'Example Adventure';
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
		return 'AdventureTest';
	}

	public Id getSoundTrackId(){
		return null;
	}

	public String getSoundTrackUrl(){
		return 'http://bob.com/sdsd';
	}

	public List<AudioEvent> getAudioEvents(){

		List<AudioEvent> ret = new List<AudioEvent>();
		ret.add(new AudioEvent('https://www.dropbox.com/s/nmcgtoj8nl5frxb/cust_s02.mp3?dl=1', 1, 0));

		return ret;
	}

	public List<ChatterEvent> getChatterEvents(){

		List<ChatterEvent> ret = new List<ChatterEvent>();

		return ret;
	}

	public ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questId){

		ChatterEvent ret;

		if(chatterComment.CommentBody.Trim() == 'right'){
			return ret;
		}else{
			ret = wrongAnswer();
		}

		return ret;
	}

	public IQuest getFirstQuest(){
		return new QuestTest();
	}

	public Boolean isFileBased(){
		return false;
	}

	public String firstFileName(){
		return null;
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



}
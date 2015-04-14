@isTest
public class QuestionTest implements IQuestion, IQuestionV3{

	public String getFullyQualifiedClass(){
		return 'QuestionTest';
	}

	public Integer getLoadTime(){
		return 30;
	}

	public Integer getPlayTime(){
		return 10 * 60;
	}

	public List<AudioEvent> getAudioEvents(){
		return new List<AudioEvent>();
	}

	public List<ChatterEvent> getChatterEvents(){
		return new List<ChatterEvent>();
	}

	public IQuestion getNextQuestion(){
		return null;// new QuestionExample();
	}

	public String getLoadingText(){
		return 'That\'s great. We\'re just loading the next one';
	}

	public ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questionId){

		ChatterEvent ret;

		if(chatterComment.CommentBody.Trim() == 'right'){
			ret = new ChatterEvent(new FeedComment());
			ret.PostComment.CommentBody = 'allgood';
			system.debug('hello');
			Beacon.markQuestionAnswered(this);
		}else{
			ret = wrongAnswer();
		}

		ret.PostComment.FeedItemId = chatterComment.FeedItemId;

		return ret;

	}

	public ChatterEvent getFirstPost(){

		ChatterEvent ce = new ChatterEvent(new FeedItem());
		ce.PostDetails.Body = 'The second question';

		return ce;
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


	public List<AudioEvent> getCorrectAnswerAudioClips(){
		return new List<AudioEvent>{ new AudioEvent('https://www.dropbox.com/s/ujx4x1sw9chjy7y/thecustomer_dialogue_s02_rough.mp3?dl=1', 0, 0) };
	}

	public List<AudioEvent> getWrongAnswerAudioClips(){
		return new List<AudioEvent>();
	}


}
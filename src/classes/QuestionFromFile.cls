global class QuestionFromFile implements IQuestion, IQuestionV3{

	private QuestionFile theFile;

	global QuestionFromFile(){}

	public QuestionFromFile(QuestionFile theFile){
		this.theFile = theFile;
	}

	global QuestionFromFile(String fileName){

		List<StaticResource> res = [SELECT Body FROM StaticResource WHERE Name = :filename];

		if(res.isEmpty())
			throw new ChannelException('No matching files');

		try{
			theFile = (QuestionFile)JSON.deserialize(res[0].Body.toString(), QuestionFile.class);
		}catch(Exception ex){
			throw new ChannelException('Read error', ex);			
		}

	}

	public String getFullyQualifiedClass(){
		return theFile.fileName;
	}

	public Integer getLoadTime(){
		return theFile.loadTime;
	}

	public Integer getPlayTime(){
		return theFile.playTime;
	}

	public List<AudioEvent> getAudioEvents(){
		return new List<AudioEvent>();
	}

	public List<ChatterEvent> getChatterEvents(){
		return new List<ChatterEvent>();
	}

	public IQuestion getNextQuestion(){

		if(!String.isBlank(theFile.nextQuestion))
			return new QuestionFromFile(theFile.nextQuestion);
		else
			return null;
	}

	public String getLoadingText(){
		return theFile.loadingText;
	}

	public ChatterEvent readPlayersChatterComment(FeedComment chatterComment, String questionId){

		ChatterEvent ret;

		String input = chatterComment.CommentBody.Trim();
		Boolean correct = false;
		Integer idx = 0;

		for(QuestionFile.Answer ans : theFile.answers){
			if(input == ans.answer){
				ret = new ChatterEvent(new FeedComment());
				ret.PostComment.CommentBody = ans.response;
				Beacon.saveSetting(theFile.filename + ';audio', String.valueOf(idx));
				Beacon.markQuestionAnswered(this);
				correct = true;
				break;
			}
			idx++;
		}

		if(!correct){
			ret = wrongAnswer();
		}

		ret.PostComment.FeedItemId = chatterComment.FeedItemId;

		return ret;

	}

	public ChatterEvent getFirstPost(){

		ChatterEvent ce = new ChatterEvent(new FeedItem());
		ce.PostDetails.Body = theFile.question;

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
		
		List<AudioEvent> ret = new List<AudioEvent>();

		String sIdx = Beacon.readSetting(theFile.fileName + ';audio');
		if(sIdx != null){

			Integer idx = Integer.valueOf(sIdx);

			for(String url : theFile.answers[idx].correctAudio){
				ret.add(new AudioEvent(url, 0, 0));
			}
		}

//		ret.add(new AudioEvent('https://www.dropbox.com/s/nmcgtoj8nl5frxb/cust_s02.mp3?dl=1', 0, 0));
//		ret.add(new AudioEvent('https://www.dropbox.com/s/miiexyxgtr0enwr/cust_s03.mp3?dl=1', 0, 0));
//		ret.add(new AudioEvent('https://www.dropbox.com/s/778etqst3w7xzhr/cust_s04.mp3?dl=1', 0, 0));

		return ret;
	}

	public List<AudioEvent> getWrongAnswerAudioClips(){
		return null;
	}

}
public class QuestFile {


	public String Filename {get; set;}
	public Integer LoadTime {get; set;}
	public Integer PlayTime {get; set;}
	public String LoadingText {get; set;}
	public String Question {get; set;}
	public List<Answer> Answers {get; set;}
	public List<WrongAnswer> IncorrectResponses {get; set;}
	public String NextQuest {get; set;}
	public String CorrectImageUrl {get; set;}

	public class Answer{
		public String Answer {get; set;}
		public String Response {get; set;}
		public List<String> CorrectAudio {get; set;}
	}

	public class WrongAnswer{
		public String Response {get; set;}
		public List<String> WrongAudio {get; set;}
	}

}
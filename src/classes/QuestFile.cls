public class QuestFile {


	public String filename {get; set;}
	public Integer loadTime {get; set;}
	public Integer playTime {get; set;}
	public String loadingText {get; set;}
	public String question {get; set;}
	public List<Answer> answers {get; set;}
	public String nextQuest {get; set;}

	public class Answer{
		public String answer {get; set;}
		public String response {get; set;}
		public List<String> correctAudio {get; set;}
	}

}
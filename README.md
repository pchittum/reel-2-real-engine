# Reel to Real

Adventure gaming on Force.com.

## Overview

Reel to Real is a learning game for Salesforce administrators and developers built on the Force.com platform. A player is lead through an adventure which is composed of a number of quests that require them to perform a set of tasks to learn about a new feature of Salesforce. Upon completion of a task then a new audio segment is unlocked which can be played to advance the story.

# Developer Notes

This section provides an overview of the system's structure and details how quests and adventures are constructed.

## Adventure and Quest System

A player embarks upon a particular "adventure" that is targeted for a particular audience (Administrator or Developer) and a particular skill/experience level. An adventure is composed of a series of quests that detail the interaction for the player with the fictional characters of the Faundation.com organisation. Within the system these are referred to as levels and questions.

### Quest Definition
A quest is defined as a combination of a text definition file, a class implementing the ILevel and ILevel2 interfaces and a Level record within the Level custom setting.

#### Level Custom Setting

This custom setting has the following fields for the quest author to fill in:

| Label               | Name                             | Data Type                           |
|:-------------------:|:--------------------------------:|:-----------------------------------:|
| Attempts            | Beacon_Game__Attempts__c	       | Number(18, 0)                       |
| Class Name          | Beacon_Game__Class_Name__c	     | Text(255) (Unique Case Insensitive) |
| Completed           | Beacon_Game__Completed__c	       | Checkbox                            |
| Current Question    | Beacon_Game__Current_Question__c | Text(255)                           |
| In Play             | Beacon_Game__In_Play__c	         | Checkbox                            |
| Last Started        | Beacon_Game__Last_Started__c	   | Date/Time                           |
| Time Spent          | Beacon_Game__Time_Spent__c	     | Number(18, 0)                       |
| Update Chatter      | Beacon_Game__Update_Chatter__c   | Checkbox                            |

In order to define a level you must populate this custom setting filling in the class name with the fully qualified class name for the class implementing ILevel and ILevel2.

#### Defining an Adventure (Level Class)

To define an Adventure you need to create a class that implements the ILevel and ILevel2 interfaces, an example implementation is shown below:

```apex
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
```

This Adventure utilises the Quest (Question) defined below.

#### Defining a Quest (Question File)

To define a Question you must create a static resource that is a serialised implementation of the QuestionFile class. An example implementation file is shown below:

```json
{
	"filename": "Question1",
	"loadTime": 30,
	"playTime": 600,
	"loadingText": "That's great. We're just loading the first tape.",
	"question": "Who are you?",
	"answers": [
					{
						"answer": "Type this to win",
						"response": "Well done, aren't you clever.",
						"correctAudio": ["link/to/audio/1", "link/to/audio/2"]
					},
					{
						"answer": "I am now writing things",
						"response": "Oooo lucky you.",
						"correctAudio": ["link/to/audio/3", "link/to/audio/4"]
					}
				],
	"nextQuestion": ""
}
```

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

In order to define a level you must populate this custom setting with the correct information. The class name should be the fully qualified class name of the class implementing the interfaces mentioned above.

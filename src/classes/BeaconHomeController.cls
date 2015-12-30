public with sharing class BeaconHomeController {
    
    public BeaconHomeController() {
        pageStatus = 'ADVENTURES';
    }

    public String creditsStuff {get; set;}
    public String pageStatus {get; set;}
    public String currentAdventureName {get; set;}

    public Integer adventureCount{
        get{
            return Adventure__c.getAll().size();
        }
    }

    public List<AdventureWrapper> adventures{
        get{

            if(adventures == null || adventures.isEmpty()){
                adventures = new List<AdventureWrapper>();

                for(Adventure__c level : Adventure__c.getAll().values()){
                    adventures.add(new AdventureWrapper(level));
                }
            }

            return adventures;

        }
        private set;
    }

    public AdventureWrapper currentAdventure{
        get{
            if(currentAdventure == null){
                currentAdventure = new AdventureWrapper(currentAdventureName);
            }

            return currentAdventure;
        }
        private set;
    }

    public String InPlayName{
        get{
            if(InPlayName == null){
                List<Adventure__c> adventures = [SELECT Name FROM Adventure__c WHERE In_Play__c = true];
                if(adventures.isEmpty())
                    InPlayName = null;
                else
                    InPlayName = adventures[0].Name;
            }

            return InPlayName;
        }
        private set;
    }

    public PageReference StartAdventure(){

        currentAdventureName = '431324486';

        pageStatus = 'INADVENTURE';

        if(!currentAdventure.adventureSettings.In_Play__c){
            currentAdventure.adventureSettings.In_Play__c = true;
            currentAdventure.adventureSettings.Last_Started__c = System.now();
            currentAdventure.adventureSettings.Attempts__c++;
            currentAdventure.getCurrentQuestSettings();
            update currentAdventure.adventureSettings;
        }


        return null;
    }

    public PageReference Reset(){

        delete [SELECT Id FROM Quest_Post__c];

        currentAdventure.adventureSettings.In_Play__c = false;
        currentAdventure.adventureSettings.Current_Quest__c = null;
        InPlayName = null;
        update currentAdventure.adventureSettings;      

        delete [SELECT Id FROM FeedItem WHERE ParentId = :Beacon.readSetting('TheGroupId')];

        return null;
    }

    public PageReference startQuest(){

        Quest_Post__c qp = currentAdventure.getCurrentQuestSettings();
        qp.Started__c = true;
        update qp;


        ChatterEvent ce = currentAdventure.getCurrentQuest().getFirstPost();

        if(ce.PostDetails != null){
            ce.PostDetails.CreatedById = Beacon.readSetting('TheGuideId');
            ce.PostDetails.ParentId = Beacon.readSetting('TheGroupId');

            insert ce.postDetails;

            qp.Post_Id__c = ce.PostDetails.Id;
            update qp;
        }


        return null;
    }

    public Id chatterTarget{
        get{
            return (Id)Beacon.readSetting('TheGroupId');
        }
    }

    private static List<AudioEvent> getAudioEvents(String levelName, Integer lastCheckLevel, Integer thisCheckLevel, Integer lastCheckQuest, Integer thisCheckQuest){

        AdventureWrapper lvl = new AdventureWrapper(levelName);
        List<AudioEvent> events = new List<AudioEvent>();

        // Random events pushed into settings as they are needed
        for(Audio_Event__c aeSetting : Audio_Event__c.getAll().values()){

            AudioEvent ae = new AudioEvent();
            if(aeSetting.ResourceUrl__c != null)
                ae.ResourceUrl = aeSetting.ResourceUrl__c;

            ae.VolumePercentage = aeSetting.Volume_Percentage__c;
            ae.Channel = Integer.valueOf(aeSetting.Channel__c);

            events.add(ae);

        }

        delete Audio_Event__c.getAll().values();
        
        return events;

    }

    @RemoteAction
    public static Events runEvents(String levelName, Integer lastCheckLevel, Integer thisCheckLevel, Integer lastCheckQuest, Integer thisCheckQuest){

        Events oeRet = new Events();
        AdventureWrapper lvl = new AdventureWrapper(levelName);
        IQuest q3 = lvl.getCurrentQuest();

        // Have they successfully answered the quest?
        if(lvl.getCurrentQuestSettings().Answered__c){
            
            oeRet.CurrentQuestAnswered = true;
            oeRet.CorrectAnswerAudio = q3.getCorrectAnswerAudioClips();
            oeRet.CorrectImage = q3.getCorrectImageUrl();

            IQuest q = lvl.getNextQuest();

            if(q == null)
                oeRet.AllQuestsAnswered = true;

        }else if(lvl.adventureSettings.Update_Chatter__c){
            oeRet.RefreshChatter = true;
            lvl.adventureSettings.Update_Chatter__c = false;
            update lvl.adventureSettings;

        }

        // Populate audio events
        oeRet.AudioEvents = getAudioEvents(levelName, lastCheckLevel, thisCheckLevel, lastCheckQuest, thisCheckQuest);
        oeRet.Action = q3.getAction();

        system.debug('oeRet ' + oeRet);

        return oeRet;
    }

    public List<String> RadioClips{
        get{
            // TODO this definately should be pushed out into the interface, being naughty for now.
            return new List<String>{
                '"https://www.dropbox.com/s/kidemzeldcjfwu7/pause_wowandflutter_amb_01.mp3?dl=1"',
                '"https://www.dropbox.com/s/k26mfepcfvll9jn/pause_eject_sunamb_02_darker.mp3?dl=1"',
                '"https://www.dropbox.com/s/ynt1v0y604lfgn2/pause_favorites_amb_04.mp3?dl=1"',
                '"https://www.dropbox.com/s/pzveg97wz2ksyr0/pause_tangled_nexttips_samb_1.mp3?dl=1"',
                '"https://www.dropbox.com/s/nxxq0j1vbwe1ejr/pause_sebastian_sunamb_01.mp3?dl=1"',
                '"https://www.dropbox.com/s/lkcs86fgoeqrmmm/pause_aroused_amb_04_drifting.mp3?dl=1"',
                '"https://www.dropbox.com/s/pzgovlpn2sfvyh9/pause_nextbrainwaves_samb_06.mp3?dl=1"',
                '"https://www.dropbox.com/s/24rilvt4cp1zvp0/pause_mindtangled_amb_01.mp3?dl=1"'
            };
        }
    }

    public PageReference startTimerExpired(){
        creditsStuff = 'Tape dequeued. You should have been quicker. Here are some credits.';
        pageStatus = 'LEVELEND';
        return null;
    }

    public PageReference playTimerExpired(){
        creditsStuff = 'Find the answers quicker will you? Here are some credits.';
        pageStatus = 'LEVELEND';
        return null;
    }

    public PageReference allCompleted(){
        creditsStuff = 'Yup, that\'s the end. Here are some credits.';
        pageStatus = 'LEVELEND';
        return null;
    }

    public PageReference refresh(){
        currentAdventure = null;
        return null;
    }

    @RemoteAction
    public static void moveTape(Integer seconds){

        checkPushTopic();

        Machine_Request__c mrq = new Machine_Request__c(SecondsToMoveTape__c = seconds);
        insert mrq;

    }

    @RemoteAction
    public static void openDrawer(){

        checkPushTopic();

 //       Machine_Request__c mrq = new Machine_Request__c(OpenDrawer__c = true);
 //       insert mrq;

    }

    private static void checkPushTopic(){

        if([SELECT Count() FROM PushTopic WHERE Name = 'NewRequests'] == 0){

            PushTopic pushTopic = new PushTopic();
            pushTopic.Name = 'NewRequests';
            pushTopic.Query = 'SELECT Id, OpenDrawer__c, PulseStartLED__c, SecondsToMoveTape__c, Completed__c FROM Machine_Request__c where Completed__c = false';
            pushTopic.ApiVersion = 33.0;
            pushTopic.Description = 'Created or updated MachineRequests without Completed flag set';
            pushTopic.NotifyForOperationCreate = true;
            pushTopic.NotifyForOperationUpdate = true;
            pushTopic.NotifyForOperationUndelete = false;
            pushTopic.NotifyForOperationDelete = false;
            pushTopic.NotifyForFields = 'Referenced';
            insert pushTopic;
        
        }
    }

    public class Events{
        public Boolean RefreshChatter {get; set;}
        public Boolean CurrentQuestAnswered {get; set;}
        public Boolean AllQuestsAnswered {get; set;}
        public List<AudioEvent> CorrectAnswerAudio {get; set;}
        public List<AudioEvent> AudioEvents {get; set;}
        public String CorrectImage {get; set;}
        public String Action {get; set;}

        public Events(){
            RefreshChatter = false;
            CurrentQuestAnswered = false;
            AllQuestsAnswered = false;
            AudioEvents = new List<AudioEvent>();
            CorrectAnswerAudio = new List<AudioEvent>();
        }
    }

}
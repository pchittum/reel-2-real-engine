global class AudioEvent{

	global AudioEvent(){}

	global AudioEvent(Id staticResourceId, Integer start){
		updateUrlFromId(staticResourceId);
		this.Start = Start;
	}

	global AudioEvent(Id staticResourceId, Integer start, Integer channel){
		updateUrlFromId(staticResourceId);
		this.Start = Start;
		this.Channel = channel;	
	}

	global AudioEvent(String url, Integer start){
		this.ResourceUrl = url;
		this.Start = Start;
	}

	global AudioEvent(String url, Integer start, Integer channel){
		this.ResourceUrl = url;
		this.Start = Start;
		this.Channel = channel;
	}

	global Decimal VolumePercentage{
		get{
			if(VolumePercentage == null)
				VolumePercentage = 0.5;

			return VolumePercentage;
		}

		set{
			if(value > 1 || value < 0)
				throw new ChannelException();

			VolumePercentage = value;
		}
	}

	global Integer Channel{
		get{
			if(Channel == null)
				Channel = 0;

			return Channel;
		}
		set{
			if(value > 5){
				throw new ChannelException();
			}

			Channel = value;
		}
	}

	global Integer Start{get; set;}

	global String ResourceUrl{get; set;}

	global void updateUrlFromId(Id staticResourceId){
		
		List<StaticResource> resources = [SELECT Name, ContentType, NamespacePrefix, SystemModstamp FROM StaticResource WHERE Id = :staticResourceId];
		if(resources.isEmpty())
			this.ResourceUrl = null;
		else
			this.ResourceUrl = '/resource/' + resources[0].SystemModstamp.getTime() + '/' + (resources[0].NamespacePrefix == null ? '' : resources[0].NamespacePrefix + '__') + resources[0].Name;

	}

}
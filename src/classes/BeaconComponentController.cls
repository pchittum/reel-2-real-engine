global class BeaconComponentController {


	@RemoteAction
	global static String hello(String input){
		system.debug('hello world ' + input);
		return 'what?';
	}


}
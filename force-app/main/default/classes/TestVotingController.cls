@isTest
public with sharing class TestVotingController {
    @isTest
    static void testGetNominations() {
        Campaign newCampaign1 = new Campaign(Name='Test Campaign 1', IsActive=true, Type='Voting');
        insert newCampaign1;
        Campaign newCampaign2 = new Campaign(Name='Test Campaign 2', IsActive=true, Type='Voting');
        insert newCampaign2;
        List<Nomination__c> nominations = new List<Nomination__c>();
        for(Integer i = 0; i < 5; i++){
            nominations.add(new Nomination__c(Name=('Test Nomination ' + (i + 1)), CampaignId__c=newCampaign1.Id));
        }
        nominations.add(new Nomination__c(Name='Test Nomination Bad', CampaignId__c=newCampaign2.Id));
        System.debug(nominations);
        insert nominations;


        Test.startTest();
        Nomination__c[] resultNominations = VotingController.getNominationList(newCampaign1.Id);
        Test.stopTest();

        System.assertEquals(5, resultNominations.size());
    } 
}

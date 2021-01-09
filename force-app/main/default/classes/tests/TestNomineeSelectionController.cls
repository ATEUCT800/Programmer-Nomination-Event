@isTest
public with sharing class TestNomineeSelectionController {
    @isTest
    static void testGetOneContact() {
        List<Contact> contacts = new List<Contact>();
        Contact testContact = new Contact(LastName='TestLastName');
        contacts.add(new Contact(LastName='LolyPop'));
        contacts.add(testContact);
        contacts.add(new Contact(LastName='Maia'));
        Test.startTest();
        insert contacts;
        Contact[] resultContacts = NomineeSelectionController.getContactList('Test');
        Test.stopTest();
        System.assertEquals(1, resultContacts.size());
        System.assertEquals(testContact, resultContacts[0]);
    } 
    @isTest
    static void testGetNominationList() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        Nomination__c newNominationTwo = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test NominationTwo');
        insert newNominationTwo;
        Test.startTest();
        List<Nomination__c> nominations = NomineeSelectionController.getNominationList(newCampaign.Id);
        Test.stopTest();
        System.assertEquals(2, nominations.size());
    }
    @isTest
    static void testGetCampaignList() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Campaign newCampaignTwo = new Campaign(Name='Test CampaignTwo', Type='Webinar', IsActive=false);
        insert newCampaignTwo;
        Test.startTest();
        List<Campaign> campaignList = NomineeSelectionController.getCampaignList();
        Test.stopTest();
        System.assertEquals(1, campaignList.size());
    }
    @isTest
    static void testCreateNominee() {
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        Test.startTest();
        NomineeSelectionController.createNominee(newNomination.Id, newContact.Id, 'Test Discription');
        List<CandidateNomination__c> listNominee = [SELECT Nominees__c, NominationId__c, Description__c FROM CandidateNomination__c WHERE NominationId__c =:newNomination.Id];
        Test.stopTest();
        System.assertEquals(1, listNominee.size());
    }
    @isTest
    static void testAuraHandledException() {
        Boolean testPass = false;
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        
        try {
            NomineeSelectionController.createNominee(newNomination.Id, newContact.Id, 'Test Discription Two');
            NomineeSelectionController.createNominee(newNomination.Id, newContact.Id, 'Test Discription');
            
        } catch (AuraHandledException e) {
            testPass = true;
        }
        System.assert(testPass);
    }
}

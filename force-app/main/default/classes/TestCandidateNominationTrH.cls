@isTest
public with sharing class TestCandidateNominationTrH {
    
    @isTest
    static void testOneMasterInsert() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        CandidateNomination__c newCN = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription');
        Test.startTest();
        Database.SaveResult result = Database.insert(newCN, false);
        Test.stopTest();
        newCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :newCN.Id];
        System.assert(result.isSuccess());
        System.assertEquals('Master', newCN.Type__c);
        System.assertEquals(null, newCN.MasterRecordID__c);
    } 

    @isTest
    static void testOneMasterAndChildInsert() {
        Campaign newCampaign = new Campaign(Name='Test Campaign', Type='Voting', IsActive=true);
        insert newCampaign;
        Contact newContact = new Contact(LastName='TestLastName');
        insert newContact;
        Nomination__c newNomination = new Nomination__c(CampaignId__c=newCampaign.Id, Name='Test Nomination');
        insert newNomination;
        CandidateNomination__c newMasterCN = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription Master');
        CandidateNomination__c newChildCN = new CandidateNomination__c(Nominees__c=newContact.Id, NominationId__c=newNomination.Id, Description__c='Test Discription Child');
        Test.startTest();
        Database.SaveResult resultMaster = Database.insert(newMasterCN, false);
        Database.SaveResult resultChild;

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
        System.runAs(u) {
            resultChild = Database.insert(newChildCN, false);
            newChildCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :newChildCN.Id];
        }
        Test.stopTest();
        newMasterCN = [SELECT Nominees__c, NominationId__c, Description__c, Type__c, MasterRecordID__c FROM CandidateNomination__c WHERE Id = :newMasterCN.Id];
        
        System.assert(resultMaster.isSuccess());
        System.assertEquals('Master', newMasterCN.Type__c);
        System.assertEquals(null, newMasterCN.MasterRecordID__c);
        System.assert(resultChild.isSuccess());
        System.assertEquals('Child', newChildCN.Type__c);
        System.assertEquals(newMasterCN.Id, newChildCN.MasterRecordID__c);
    } 
}
